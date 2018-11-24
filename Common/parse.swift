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
    let s = string.mutable(attributes: defaultAttribute)
    let r = NSRange(location: 0, length: s.length)
    var set = tags
    if set.contains("<S>") { set.remove("<J>") }
    if set.contains("<f>") { set.remove("<J>") }
    for element in set {
        switch element {
        case "<i>": s.addAttribute(.font, value: NSFont(name:"Verdana-Italic", size:13.0)!, range: r)
                    s.addAttribute(.foregroundColor, value: NSColor.secondaryLabelColor,    range: r)
        case "<J>",
             "<r>": s.addAttribute(.foregroundColor, value: NSColor.systemRed,   range: r)
        case "<n>": s.addAttribute(.foregroundColor, value: NSColor.systemGray,  range: r)
        case "<m>": s.addAttribute(.foregroundColor, value: NSColor.systemNavy,  range: r)
        case "<l>": s.addAttribute(.foregroundColor, value: NSColor.systemNavy,  range: r)
        case "<S>": s.addAttribute(.foregroundColor, value: NSColor.systemBrown, range: r)
                    s.addAttribute(.font, value: NSFont.systemFont(ofSize: 9),   range: r)
                    s.addAttribute(.baselineOffset,  value: 5.0,                 range: r)
        case "<f>": s.addAttribute(.foregroundColor, value: NSColor.systemGray,  range: r)
                    s.addAttribute(.font, value: NSFont.systemFont(ofSize: 9),   range: r)
                    s.addAttribute(.baselineOffset,  value: 5.0,                 range: r)
        default: break
        }
    }
    return s
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

