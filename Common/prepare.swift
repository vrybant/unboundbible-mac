//
//  prepare.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

private let dictionary = [
    "<FR>": "<J>",
    "<Fr>":"</J>",
    "<FI>": "<i>", // italic
    "<Fi>":"</i>",
    "<FO>": "<t>", // quote
    "<Fo>":"</t>",
    "<TS>": "<h>", // title
    "<Ts>":"</h>",
    "<RF>": "<f>", // footnote
    "<RF ": "<f ",
    "<Rf>":"</f>"]

private func replaceMyswordTags(_ string: inout String) {
    for item in dictionary {
        if string.contains(item.key) {
            string = string.replace(item.key, with: item.value)
        }
    }
}

private func myswordStrongsToUnbound(_ string: String) -> String {
    let list = xmlToList(string: string)
    result = ""
    for item in list {
        if item.hasPrefix("<W") {
            let number = item.replace("<W", with: "").replace(">", with: "")
            result += "<S>" + number + "</S>"
        } else {
            result += item
        }
    }
    return result
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
    string = string.replace("<f>", with: "<f>✻[~").replace("</f>", with: "~]</f>")
    string = string.cut(from: "[~", to: "~]")
}

private func footnotesEx(_ string: inout String) {
    string = string.replace("<f ", with: "<f><").replace("</f>", with: "~]</f>")
    extractMarkers(&string)
    string = string.cut(from: "[~", to: "~]")
}

func prepare(_ string: String, format: FileFormat, purge: Bool = true)-> String {
    var string = string

    if format == .mysword {
        if string.contains("<W") { string = myswordStrongsToUnbound(string) }
        replaceMyswordTags(&string)
    }

    if format == .unbound || format == .mysword {
        if !purge && string.contains("<f>") { footnotes(&string) }
        if !purge && string.contains("<f ") { footnotesEx(&string) }
    }
    
    string = string.cut(from: "<h>", to: "</h>")
    if  purge { string = string.cut(from: "<f", to:"</f>") }
    if !purge { string = string.replace("</f><f>", with: "</f> <f>") }
    string = string.replace("</S><S>", with: "</S> <S>")
    
    return string
}
