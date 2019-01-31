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
    return [NSAttributedStringKey.foregroundColor: NSColor.labelColor, NSAttributedStringKey.font: defaultFont]
}

private func attrStringFromTags(_ string: String, tags: Set<String>, small: Bool) -> NSAttributedString {
    let s = string.mutable(attributes: defaultAttributes)
    if small { s.addAttribute(.font, value: NSFont.systemFont(ofSize: 12)) }

    if tags.contains("<m>") { s.addAttribute(.foregroundColor, value: NSColor.systemGray  ) }
    if tags.contains("<n>") { s.addAttribute(.foregroundColor, value: NSColor.systemGray  ) }
    if tags.contains("<a>") { s.addAttribute(.foregroundColor, value: NSColor.systemGray  ) }
    if tags.contains("<J>") { s.addAttribute(.foregroundColor, value: NSColor.systemRed   ) }
    if tags.contains("<S>") { s.addAttribute(.foregroundColor, value: NSColor.systemBrown ) }
    if tags.contains("<r>") { s.addAttribute(.foregroundColor, value: NSColor.systemRed   ) }
    if tags.contains("<f>") { s.addAttribute(.foregroundColor, value: NSColor.systemTeal  ) }
    if tags.contains("<l>") { s.addAttribute(.foregroundColor, value: NSColor.systemNavy  ) }
    if tags.contains("<b>") { s.addAttribute(.foregroundColor, value: NSColor.systemBrown ) }

    if tags.intersection(["<i>","<em>"]) != [] {
        s.addAttribute(.font, value: NSFont(name:"Verdana-Italic", size: small ? 12 : 13)!)
        s.addAttribute(.foregroundColor, value: NSColor.secondaryLabelColor   )
    }

    if tags.contains("<S>") { s.addAttribute(.font, value: NSFont.systemFont(ofSize:  9)) }
    if tags.contains("<m>") { s.addAttribute(.font, value: NSFont.systemFont(ofSize:  9)) }
    if tags.contains("<f>") { s.addAttribute(.font, value: NSFont.systemFont(ofSize: 11)) }
        
    if tags.intersection(["<S>","<m>","<f>"]) != [] {
        s.addAttribute(.baselineOffset, value: 5.0)
    }
    return s
}

private func attrStringFromHtml(_ string: String, tags: Set<String>) -> NSAttributedString {
    let s = string.mutable(attributes: defaultAttributes)
    s.addAttribute(.font, value: NSFont.systemFont(ofSize: 13))
    
    if tags.contains("<a>") {
        s.addAttribute(.foregroundColor, value: NSColor.systemGray  )
    }
    if tags.intersection(["<b>","<strong>"]) != [] {
        s.addAttribute(.foregroundColor, value: NSColor.systemBrown )
    }
    if tags.intersection(["<i>","<em>"]) != [] {
        s.addAttribute(.font, value: NSFont(name:"Verdana-Italic", size: 12)!)
    }
    if tags.contains("<sup>") {
        s.addAttribute(.baselineOffset, value: 5.0)
    }
    return s
}

private func htmlReplacement(_ string: String) -> String {
    return string
        .replace( "&nbsp;", with:  " ")
        .replace( "&quot;", with: "\"")
        .replace("&lquot;", with:  "«")
        .replace("&rquot;", with:  "»")
        
        .replace( "<p/>", with: "<p>" )
        .replace("<br/>", with: "<br>")
        .replace( "<td>", with: "<br>")
        .replace( "<tr>", with: "<br>")
        .replace("</td>", with: "<br>")
        .replace("</tr>", with: "<br>")

        .replace("<p>", with: string.contains("</p>") ? "" : "<br>")

        .replace("</p>", with: "<br>")
        .replace("<br>", with: "\n\t")
        .replace(  "  ", with:    " ")
}

func parse(_ string: String, jtag: Bool = false, small: Bool = false) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()
    //return string.mutable(attributes: defaultAttributes) // show tags

    let string = string.replace("</p>", with: "\n")

    let list = xmlToList(string: string)
    var tags = Set<String>()
    
    for s in list {
        if s.hasPrefix("<") {
            var s = s
            if s.hasPrefix("<a ") { s = "<a>" }
            if s.hasPrefix("</") {
                tags.remove(s.replace("/", with: ""))
            } else {
                tags.insert(s)
            }
        } else {
            if !jtag { tags.remove("<J>") }
            let attrString = attrStringFromTags(s, tags: tags, small: small)
            result.append(attrString)
        }
    }
    return result
}

func html(_ string: String) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()
    let string = "\t" + htmlReplacement(string)
    
    let list = xmlToList(string: string)
    var tags = Set<String>()
    
    for s in list {
        if s.hasPrefix("<") {
            var s = s.lowercased()
            if s.hasPrefix("<a ") { s = "<a>" }
            if s.hasPrefix("</") {
                tags.remove(s.replace("/", with: ""))
            } else {
                tags.insert(s)
            }
        } else {
            let attrString = attrStringFromHtml(s, tags: tags)
            result.append(attrString)
        }
    }
    return result
}
