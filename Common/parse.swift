//
//  parse.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation
import Cocoa

var defaultFont = NSFont.systemFont(ofSize: 14)

var defaultAttribute: [NSAttributedStringKey : Any] {
    return [NSAttributedStringKey.foregroundColor: NSColor.labelColor, NSAttributedStringKey.font: defaultFont] as [NSAttributedStringKey : Any]
}

private func attrStringFromTags(_ string: String, tags: Set<String>) -> NSAttributedString {
    let s = string.mutable(attributes: defaultAttribute)
    var tags = tags
    let set : Set = ["<S>","<RF>","FI"]
    if !tags.isDisjoint(with: set) { tags.remove("<FR>") }
    for element in tags {
        switch element {
        case "<FI>": s.addAttribute(.font, value: NSFont(name:"Verdana-Italic", size:13.0)!)
                     s.addAttribute(.foregroundColor, value: NSColor.secondaryLabelColor   )
        case "<FR>",
              "<r>": s.addAttribute(.foregroundColor, value: NSColor.systemRed   )
        case  "<n>": s.addAttribute(.foregroundColor, value: NSColor.systemGray  )
        case  "<m>": s.addAttribute(.foregroundColor, value: NSColor.systemNavy  )
        case  "<l>": s.addAttribute(.foregroundColor, value: NSColor.systemNavy  )
        case  "<S>": s.addAttribute(.foregroundColor, value: NSColor.systemBrown )
                     s.addAttribute(.font, value: NSFont.systemFont(ofSize: 9)   )
                     s.addAttribute(.baselineOffset,  value: 5.0                 )
        case "<RF>": s.addAttribute(.foregroundColor, value: NSColor.systemBrown )
                     s.addAttribute(.font, value: NSFont.systemFont(ofSize: 9)   )
                     s.addAttribute(.baselineOffset,  value: 2.0                 )
        default: break
        }
        switch element.lowercased() {
        case "<i>",
             "<em>": s.addAttribute(.font, value: NSFont(name:"Verdana-Italic", size:13.0)!)
                     s.addAttribute(.foregroundColor, value: NSColor.secondaryLabelColor   )
        default: break
        }
    }
    return s
}

func parse(_ string: String, jtag: Bool = false) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()
    //return string.mutable(attributes: defaultAttribute) // show tags
    
    let list = xmlToList(string: string)
    var tags = Set<String>()
    
    for s in list {
        if s.hasPrefix("<") {
            if tags.contains(s.uppercased()) {
                tags.remove(s.uppercased())
            } else {
                if s.hasPrefix("</") {
                    let r = s.replace("/", with: "")
                    tags.remove(r)
                } else {
                    tags.insert(s)
                }
            }
        } else {
            let attrString = attrStringFromTags(s, tags: tags)
            result.append(attrString)
        }
    }
    return result
}

