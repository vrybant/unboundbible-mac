//
//  parse.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation
import Cocoa

var defaultFont = NSFont.systemFont(ofSize: 14)

var defaultAttributes: [NSAttributedStringKey : Any] {
    return [NSAttributedStringKey.foregroundColor: NSColor.labelColor, NSAttributedStringKey.font: defaultFont] as [NSAttributedStringKey : Any]
}

private func attrStringFromTags(_ string: String, tags: Set<String>, small: Bool) -> NSAttributedString {
    let s = string.mutable(attributes: defaultAttributes)
    if small { s.addAttribute(.font, value: NSFont.systemFont(ofSize: 12)) }

    var tags = tags
    let set : Set = ["<S>","<RF>","FI"]
    if !tags.isDisjoint(with: set) { tags.remove("<FR>") }
    
    for tag in tags {
        var tag = tag
        let italic = ["<i>","<em>"]
        if italic.contains(tag.lowercased()) { tag = "<FI>" }
        
        switch tag {
        case "<FI>": s.addAttribute(.font, value: NSFont(name:"Verdana-Italic", size: small ? 12 : 13)!)
                     s.addAttribute(.foregroundColor, value: NSColor.secondaryLabelColor   )
        case "<FR>",
              "<r>": s.addAttribute(.foregroundColor, value: NSColor.systemRed   )
        case  "<n>": s.addAttribute(.foregroundColor, value: NSColor.systemGray  )
        case  "<m>": s.addAttribute(.foregroundColor, value: NSColor.systemNavy  )
        case  "<l>": s.addAttribute(.foregroundColor, value: NSColor.systemNavy  )
        case  "<S>": s.addAttribute(.foregroundColor, value: NSColor.systemBrown )
                     s.addAttribute(.font, value: NSFont.systemFont(ofSize: 9)   )
                     s.addAttribute(.baselineOffset,  value: 5.0                 )
        case "<RF>": s.addAttribute(.foregroundColor, value: NSColor.systemTeal  )
                     s.addAttribute(.font, value: NSFont.systemFont(ofSize: 11)  )
                     s.addAttribute(.baselineOffset,  value: 5.0                 )
        case "<strong>",
             "<b>" : s.addAttribute(.foregroundColor, value: NSColor.systemBrown )
        default: break
        }
    }
    return s
}

func parse(_ string: String, jtag: Bool = false, small: Bool = false) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()
    //return string.mutable(attributes: defaultAttribute) // show tags

    let string = string.replace("</p>", with: "\n")
    
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
            if !jtag { tags.remove("<FR>") }
            let attrString = attrStringFromTags(s, tags: tags, small: small)
            result.append(attrString)
        }
    }
    return result
}

