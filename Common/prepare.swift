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
    "<E>" : "<n>", // english translation
    "<e>" :"</n>",
    "<T>" : "<n>", // translation
    "<t>" :"</n>",
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
    var result = ""

    for item in list {
        if item.hasPrefix("<WH") || item.hasPrefix("<WG") {
            let number = item.replace("<W", with: "").replace(">", with: "")
            result += "<S>" + number + "</S>"
        } else if item.hasPrefix("<WT") {
            let code = item.replace("<WT", with: "").replace(">", with: "")
            result += "<m>" + code + "</m>"
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
        string = string.cut(from: "<X>", to:"<x>") // transliteration
        if string.contains("<W") { string = myswordStrongsToUnbound(string) }
        replaceMyswordTags(&string)
        string = string.replace("¶", with: "")
    }

    if format == .unbound || format == .mysword {
        if string.contains("<f>") { footnotes(&string) }
        if string.contains("<f ") { footnotesEx(&string) }
    }
    
    string = string.cut(from: "<h>", to: "</h>")
    if purge { string = string.cut(from: "<f>", to:"</f>") }
    string = string.replace("><", with: "> <")

    return string
}
