//
//  parse.swift
//  Unbound-Bible-macOS
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation
import Cocoa

var defaultFont = NSFont.systemFont(ofSize: 14)

var defaultAttribute: [NSAttributedStringKey : Any] {
    return [NSAttributedStringKey.foregroundColor: NSColor.labelColor, NSAttributedStringKey.font: defaultFont] as [NSAttributedStringKey : Any]
}

func xmlToList(string: String) -> [String] {
    var result: [String] = []
    var temp = ""
    
    for c in string {
        if c == "<" {
            result.append(temp)
            temp = ""
        }
        temp.append(c)
        
        if c == ">" {
            result.append(temp)
            temp = ""
        }
    }
    if !temp.isEmpty {
        result.append(temp)
    }
    return result
}

func attrStringFromTags(_ string: String, tags: Set<String>) -> NSAttributedString {
    let result = string.mutable(attributes: defaultAttribute)
    let range = NSRange(location: 0, length: result.length)
    var set = tags
    if set.contains("<S>") { set.remove("<J>") }
    if set.contains("<f>") { set.remove("<J>") }
    for element in set {
        switch element {
        case "<i>": result.addAttribute(.font, value: NSFont(name:"Verdana-Italic", size:13.0)!, range: range)
                    result.addAttribute(.foregroundColor, value: NSColor.secondaryLabelColor, range: range)
        case "<J>",
             "<r>": result.addAttribute(.foregroundColor, value: NSColor.systemRed, range: range)
        case "<n>": result.addAttribute(.foregroundColor, value: NSColor.systemGray, range: range)
        case "<m>": result.addAttribute(.foregroundColor, value: NSColor.systemNavy, range: range)
        case "<l>": result.addAttribute(.foregroundColor, value: NSColor.systemNavy, range: range)
        case "<S>": result.addAttribute(.foregroundColor, value: NSColor.systemBrown, range: range)
                    result.addAttribute(.font, value: NSFont.systemFont(ofSize: 9), range: range)
                    result.addAttribute(.baselineOffset, value: 5.0, range: range)
        case "<f>": result.addAttribute(.foregroundColor, value: NSColor.systemGray, range: range)
                    result.addAttribute(.font, value: NSFont.systemFont(ofSize: 9), range: range)
                    result.addAttribute(.baselineOffset, value: 5.0, range: range)
        default: break
        }
    }
    return result
}

func replaceTags(list: inout [String], jtag: Bool) {
    if list.isEmpty { return }

    for i in 0...list.count-1 {
        switch list[i] {
            case "<FI>": list[i] = "<i>"
            case "<Fi>": list[i] = "</i>"
            case "<FR>": list[i] = "<J>"
            case "<Fr>": list[i] = "</J>"
            default: break
        }
        if !jtag {
            if list[i] == "<J>" { list[i] = "<->" }
        }
    }
}

func parse(_ string: String, jtag: Bool) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()
    let string = string.replace("</S><S>","</S> <S>") // strongs
                       .replace(" <f>","<f>")         // footnotes

    var list = xmlToList(string: string)
    replaceTags(list: &list, jtag: jtag)
    
    var tags = Set<String>()
    
    for s in list {
        if s.hasPrefix("<") {
            if s.hasPrefix("</") {
                let r = s.replace("/", "")
                tags.remove(r)
            } else {
                tags.insert(s)
            }
        } else {
            let attrString = attrStringFromTags(s, tags: tags)
//          if tags.contains("<f>") { continue } // remove footnotes
            result.append(attrString)
        }
    }
    return result
}

