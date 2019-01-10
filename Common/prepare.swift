//
//  prepare.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

private let dictionary = [
      "<J>":"<FR>",
     "</J>":"<Fr>",
      "<t>":"<FO>", // quote
     "</t>":"<Fo>",
      "<h>":"<TS>", // title
     "</h>":"<Ts>",
      "<f>":"<RF>", // footnote
     "</f>":"<Rf>"]

private func replaceTags(_ string: inout String) {
    for item in dictionary {
        if string.contains(item.key) {
            string = string.replace(item.key, with: item.value)
        }
    }
}

private func strongs(_ string: inout String) {
    let list = xmlToList(string: string)
    string = ""
    for item in list {
        if item.hasPrefix("<W") {
            let number = item.replace("<W", with: "").replace(">", with: "")
            string += "<S>" + number + "</S>"
        } else {
            string += item
        }
    }
}

private func extractFootnoteMarker(_ string: String) -> String {
    var result = ""
    if let range = string.range(of: "=") {
        result = String(string[range.lowerBound..<string.endIndex])
    }
    return result.replace(">", with: "")
}

private func extractMarkers(_ string: inout String) {
    let list = xmlToList(string: string)
    string = ""
    for item in list {
        if item.hasPrefix("<q=") {
            let marker = item.replace("<q=", with: "").replace(">", with: "")
            string += marker + " [~"
        } else {
            string += item
        }
    }
}

private func footnotes(_ string: inout String) {
    string = string.replace("<RF>", with: "<RF>✻[~").replace("<Rf>", with: "~]<Rf>")
    string = string.cut(from: "[~", to: "~]")
}

private func footnotesEx(_ string: inout String) {
    string = string.replace("<RF ", with: "<RF><").replace("<Rf>", with: "~]<Rf>")
    extractMarkers(&string)
    string = string.cut(from: "[~", to: "~]")
}

func prepare(_ string: String, format: FileFormat, purge: Bool = true)-> String {
    var string = string

    if format == .unbound {
        if string.contains("<W") { strongs(&string) }
        if !purge && string.contains("<RF>") { footnotes(&string) }
        if !purge && string.contains("<RF ") { footnotesEx(&string) }
    }
    
    if format == .mybible { replaceTags(&string) }

    string = string.cut(from: "<TS>", to: "<Ts>")
    if  purge { string = string.cut(from: "<RF", to:"<Rf>") }
    if !purge { string = string.replace("<Rf><RF>", with: "<Rf> <RF>") }
    string = string.replace("</S><S>", with: "</S> <S>")
    
    return string
}
