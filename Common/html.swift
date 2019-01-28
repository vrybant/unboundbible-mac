//
//  parse.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation
import Cocoa

private func attrStringFromHtml(_ string: String, tags: Set<String>) -> NSAttributedString {
    let s = string.mutable(attributes: defaultAttributes)
    s.addAttribute(.font, value: NSFont.systemFont(ofSize: 13))
    
    for tag in tags {
        switch tag {
        case "<i>","<em>":
                     s.addAttribute(.font, value: NSFont(name:"Verdana-Italic", size: 13)!)
                     s.addAttribute(.foregroundColor, value: NSColor.secondaryLabelColor  )
        case "<a>" : s.addAttribute(.foregroundColor, value: NSColor.systemGray  )
        case "<b>","<strong>" :
                    s.addAttribute(.foregroundColor, value: NSColor.systemBrown )
        case "<sup>" :
                    s.addAttribute(.foregroundColor, value: NSColor.systemTeal  )
                    s.addAttribute(.font, value: NSFont.systemFont(ofSize: 11)  )
                    s.addAttribute(.baselineOffset,  value: 5.0                 )
        default: break
        }
    }
    return s
}

func replacement(_ string: String) -> String {
    return string
        .replace( "<p/>", with: "<p>" )
        .replace("<br/>", with: "<br>")
        .replace( "<td>", with: "<br>")
        .replace( "<tr>", with: "<br>")
        .replace("</td>", with: "<br>")
        .replace("</tr>", with: "<br>")
        
        .replace( "&nbsp;", with:  " ")
        .replace( "&quot;", with: "\"")
        .replace("&lquot;", with:  "«")
        .replace("&rquot;", with:  "»")
    
        .replace( "<p>", with:  "<p>\n\t")
        .replace("</p>", with: "</p>\n\t")
        .replace("<br>", with: "<br>\n\t")
        
        .replace("  ", with: " ")
}

func html(_ string: String, jtag: Bool = false, small: Bool = false, html: Bool = false) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()
    //return string.mutable(attributes: defaultAttributes) // show tags

    let string = "\t" + replacement(string)
   
    let list = xmlToList(string: string)
    var tags = Set<String>()
    
    for s in list {
        if s.hasPrefix("<") {
            var s = s.lowercased()
            if s.hasPrefix("</") {
                                                                    //result.append(attrStringFromHtml(s, tags: tags)) // debug
                let r = s.replace("/", with: "")
                tags.remove(r)
            } else {
                if s.hasPrefix("<a ") { s = "<a>" }
                if s.hasPrefix("<p ") { s = "<p>" }
                let r = s.replace("/", with: "")
                tags.insert(r)
                                                                    //result.append(attrStringFromHtml(s, tags: tags)) // debug
            }
        } else {
            let attrString = attrStringFromHtml(s, tags: tags)
            result.append(attrString)
        }
    }
    return result
}

