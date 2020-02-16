//
//  parse.swift
//  Unbound Bible
//
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import Foundation

var defaultFont = Font.init(name: "Helvetica", size: 14) ?? Font.systemFont(ofSize: 14)

var defaultAttributes: [NSAttributedString.Key : Any] {
    return [NSAttributedString.Key.foregroundColor: Color.labelColor, NSAttributedString.Key.font: defaultFont]
}

private func attrStringFromTags(_ string: String, tags: Set<String>, small: Bool) -> NSAttributedString {
    let s = string.mutable(attributes: defaultAttributes)
    if small { s.addAttribute(.font, value: Font.systemFont(ofSize: 12)) }

    if tags.contains("<m>") { s.addAttribute(.foregroundColor, value: Color.systemGray  ) }
    if tags.contains("<n>") { s.addAttribute(.foregroundColor, value: Color.systemGray  ) }
    if tags.contains("<v>") { s.addAttribute(.foregroundColor, value: Color.systemGray  ) }
    if tags.contains("<a>") { s.addAttribute(.foregroundColor, value: Color.systemGray  ) }
    if tags.contains("<J>") { s.addAttribute(.foregroundColor, value: Color.systemRed   ) }
    if tags.contains("<S>") { s.addAttribute(.foregroundColor, value: Color.systemBrown ) }
    if tags.contains("<r>") { s.addAttribute(.foregroundColor, value: Color.systemRed   ) }
    if tags.contains("<f>") { s.addAttribute(.foregroundColor, value: Color.systemTeal  ) }
    if tags.contains("<l>") { s.addAttribute(.foregroundColor, value: Color.systemNavy  ) }
    if tags.contains("<b>") { s.addAttribute(.foregroundColor, value: Color.systemBrown ) }

    if tags.intersection(["<i>","<em>"]) != [] {
        s.addAttribute(.font, value: Font(name:"Verdana-Italic", size: small ? 12 : 13)!)
        s.addAttribute(.foregroundColor, value: Color.secondaryLabelColor)
    }
    if tags.contains("<S>") { s.addAttribute(.font, value: Font.systemFont(ofSize:  9)) }
    if tags.contains("<m>") { s.addAttribute(.font, value: Font.systemFont(ofSize:  9)) }
    if tags.contains("<f>") { s.addAttribute(.font, value: Font.systemFont(ofSize: 11)) }
        
    if tags.intersection(["<S>","<m>","<f>"]) != [] {
        s.addAttribute(.baselineOffset, value: 5.0)
    }
    
    return s
}

private func attrStringFromHtml(_ string: String, tags: Set<String>) -> NSAttributedString {
    let s = string.mutable(attributes: defaultAttributes)
    s.addAttribute(.font, value: Font.systemFont(ofSize: 13))
    
    if tags.contains("<a>") {
        s.addAttribute(.foregroundColor, value: Color.systemGray  )
    }
    if tags.intersection(["<b>","<strong>"]) != [] {
        s.addAttribute(.foregroundColor, value: Color.systemBrown )
    }
    if tags.intersection(["<i>","<em>"]) != [] {
        s.addAttribute(.font, value: Font(name:"Verdana-Italic", size: 12)!)
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
        .replace("<br/>", with: "\n\t")
        .replace( "<td>", with: "\n\t")
        .replace( "<tr>", with: "\n\t")
        .replace("</td>", with: "\n\t")
        .replace("</tr>", with: "\n\t")

        .replace("<p>", with: string.contains("</p>") ? "" : "\n\t")

        .replace("<br>", with: "\n\t")
        .replace("</p>", with: "\n\t")
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
    let string = htmlReplacement(string)
    
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
