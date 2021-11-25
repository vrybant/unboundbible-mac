//
//  prepare.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Foundation

private let dictionary = [
    "<FR>": "<J>", "<Fr>":"</J>",
    "<-1>": "<S>", "<-2>":"</S>", // strong
    "<-3>": "<m>", "<-4>":"</m>", // morphology
    "<FI>": "<i>", "<Fi>":"</i>", // italic
    "<FO>": "<t>", "<Fo>":"</t>", // quote
    "<TS>": "<h>", "<Ts>":"</h>", // title
    "<E>" : "<n>", "<e>" :"</n>", // english translation
    "<T>" : "<n>", "<t>" :"</n>", // translation
    "<X>" : "<m>", "<x>" :"</m>", // transliteration
    "<RF>": "<f>", "<RF ": "<f ", // footnote
    "<Rf>":"</f>"]

private func replaceMyswordTags(_ string: inout String) {
    for item in dictionary {
        if string.contains(item.key) {
            string = string.replace(item.key, with: item.value)
        }
    }
    string = string.replace("¶", with: "")
}

private func replaceMybibleTags(_ string: inout String) {
    string = string.replace(  "<t>", with: "  ")
    string = string.replace( "</t>", with: "  ")
    string = string.replace("<pb/>", with: "  ")
    string = string.replace("<br/>", with: "  ")
}

private func enabledTag(_ tag: String) -> Bool {
    for item in dictionary {
        if tag.hasPrefix(item.value) { return true }
    }
    return false
}

private func cleanUnabledTags(_ string: inout String) {
    let list = xmlToList(string: string)
    string = ""

    for item in list {
        if item.hasPrefix("<") && !enabledTag(item) { continue }
        string += item
    }
    string = string.removeDoubleSpace.trimmed
}

private func mybibleStrongsToMysword(_ string: String, nt: Bool) -> String {
    let symbol = nt ? "G" : "H"
    let text = "<S>" + symbol
    return string.replace(  "<S>", with: text)
}

private func myswordStrongsToUnbound(_ string: inout String) {
    if !string.contains("<W") { return }
    
    let list = xmlToList(string: string)
    string = ""
    
    for item in list {
        if item.hasPrefix("<WH") {
            let number = item.replace("<W", with: "").replace(">", with: "")
            string += "<S>" + number + "</S>"
        } else if item.hasPrefix("<WG") {
            let number = item.replace("<W", with: "").replace(">", with: "")
            string += "<S>" + number + "</S>"
        } else if item.hasPrefix("<WT") {
            let code = item.replace("<WT", with: "").replace(">", with: "")
            string += "<m>" + code + "</m>"
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
    string = string.replace("<f>", with: "<f>✻[~").replace("</f>", with: "~]</f>")
    string = string.cut(from: "[~", to: "~]")
}

private func footnotesEx(_ string: inout String) {
    string = string.replace("<f ", with: "<f><").replace("</f>", with: "~]</f>")
    extractMarkers(&string)
    string = string.cut(from: "[~", to: "~]")
}

func coercion(_ string: inout String, format: FileFormat, nt: Bool) {
    if format == .mysword {
        myswordStrongsToUnbound(&string)
        replaceMyswordTags(&string)
    }
    if format == .mybible {
        replaceMybibleTags(&string)
    }
    
   cleanUnabledTags(&string)
}

func preparation(_ string: String, format: FileFormat, nt: Bool, purge: Bool = true) -> String {
    var string = string
    
    if format != .unbound {
        coercion(&string, format: format, nt: nt)
    }
    if format == .unbound || format == .mysword {
        if string.contains("<f>") { footnotes(&string) }
        if string.contains("<f ") { footnotesEx(&string) }
    }

    if purge { string = string.cut(from: "<f>", to:"</f>") }
    string = string.cut(from: "<h>", to: "</h>")
    string = string.replace("><", with: "> <")
    
    return string
}
