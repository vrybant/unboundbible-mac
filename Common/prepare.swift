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
        string = string.replace(item.key, item.value)
    }
}

private func strongs(_ string: inout String) {
    let list = xmlToList(string: string)
    string = ""
    for item in list {
        if item.hasPrefix("<W") {
            let number = item.replace("<W","").replace(">","")
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
    return result.replace(">","")
}

private func extractMarkers(_ string: inout String) {
    let list = xmlToList(string: string)
    var string = ""
    for item in list {
        if item.hasPrefix("<q=") {
            let marker = item.replace("<q=","").replace(">","")
            string += marker + "[~"
        } else {
            string += item
        }
    }
}

private func footnotes(_ string: inout String) {
    string = string.replace("<RF>","<RF>*[~").replace("<Rf>","~]<Rf>")
    string = string.cut(from: "[~", to: "~]")
}

private func footnotesEx(_ string: inout String) {
    string = string.replace("<RF ","<RF><").replace("<Rf>","~]<Rf>")
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
    if purge { string = string.cut(from: "<RF", to:"<Rf>") }
    string = string.replace("</S><S>","</S> <S>")

    return string
}
