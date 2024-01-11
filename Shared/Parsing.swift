//
//  parse.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation

private func attrStringFromTags(_ string: String, tags: Set<String>, small: Bool) -> NSAttributedString {
    let discount : CGFloat = small ? 2 : 1
    let linkColor = macOS ? Color.systemNavy : Color.darkGray

    let     smallFont = Font(name: defaultFont.fontName,   size: defaultFont.pointSize - 2)!
    let    italicFont = Font(name: "HelveticaNeue-Italic", size: defaultFont.pointSize - discount) ?? defaultFont
    let subscriptFont = Font(name: defaultFont.fontName,   size: defaultFont.pointSize - 5)!
    let  footnoteFont = Font(name: defaultFont.fontName,   size: defaultFont.pointSize - 3)!

    let s = NSMutableAttributedString(string: string, attributes: defaultAttributes)
    if small { s.addAttribute(.font, value: smallFont) }

    if tags.contains("<m>") { s.addAttribute(.foregroundColor, value: Color.systemGray  ) }
    if tags.contains("<n>") { s.addAttribute(.foregroundColor, value: Color.systemGray  ) }
    if tags.contains("<v>") { s.addAttribute(.foregroundColor, value: Color.systemGray  ) }
    if tags.contains("<a>") { s.addAttribute(.foregroundColor, value: Color.systemGray  ) }
    if tags.contains("<J>") { s.addAttribute(.foregroundColor, value: Color.systemRed   ) }
    if tags.contains("<S>") { s.addAttribute(.foregroundColor, value: Color.systemBrown ) }
    if tags.contains("<r>") { s.addAttribute(.foregroundColor, value: Color.systemRed   ) }
    if tags.contains("<f>") { s.addAttribute(.foregroundColor, value: Color.systemTeal  ) }
    if tags.contains("<l>") { s.addAttribute(.foregroundColor, value: linkColor         ) }

    if tags.intersection(["<i>","<em>"]) != [] {
        s.addAttribute(.font, value: italicFont )
        s.addAttribute(.foregroundColor, value: Color.secondaryLabelColor)
    }
    if tags.contains("<S>") { s.addAttribute(.font, value: subscriptFont) }
    if tags.contains("<m>") { s.addAttribute(.font, value: subscriptFont) }
    if tags.contains("<f>") { s.addAttribute(.font, value: footnoteFont ) }
        
    if tags.intersection(["<S>","<m>","<f>"]) != [] {
        s.addAttribute(.baselineOffset, value: 5.0)
    }
    
    return s
}

private func attrStringFromHtml(_ string: String, tags: Set<String>, small: Bool) -> NSAttributedString {
    let discount : CGFloat = small ? 2 : 1
    
    let  smallFont = Font(name: defaultFont.fontName,  size: defaultFont.pointSize - 2)!
    let italicFont = Font(name: "HelveticaNeue-Italic", size: defaultFont.pointSize - discount) ?? defaultFont
    let   boldFont = Font(name: "HelveticaNeue-Bold", size: defaultFont.pointSize - discount) ?? defaultFont
    
    let s = NSMutableAttributedString(string: string, attributes: defaultAttributes)
    if small { s.addAttribute(.font, value: smallFont) }

    if tags.contains("<a>") {
        s.addAttribute(.foregroundColor, value: Color.systemGray  )
    }
    if tags.contains("<h>") {
        s.addAttribute(.font, value: boldFont)
    }
    if tags.intersection(["<b>","<strong>"]) != [] {
        s.addAttribute(.foregroundColor, value: Color.systemBrown )
    }
    if tags.intersection(["<i>","<em>"]) != [] {
        s.addAttribute(.font, value: italicFont)
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
        .replace( "<td>", with: "\n\t")
        .replace( "<tr>", with: "\n\t")
        .replace("</td>", with: "\n\t")
        .replace("</tr>", with: "\n\t")

        .replace("<p>", with: string.contains("</p>") ? "" : "\n\t")
        .replace("</p>", with: "\n")
        .replace("<br>", with: "\n")
        .replace(  "  ", with:  " ")
}

func parse(_ string: String, jtag: Bool = false, small: Bool = false) -> NSAttributedString {
    let result = NSMutableAttributedString()
    // return NSMutableAttributedString(string: string, attributes: defaultAttributes) // show tags

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
            var s = s
            if s.hasPrefix(" ") && result.string.hasSuffix(" ") { s = s.removeLeadingChar }
            let attrString = attrStringFromTags(s, tags: tags, small: small)
            result.append(attrString)
        }
    }
    return result
}

func html(_ string: String, small: Bool = false) -> NSAttributedString {
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
            let attrString = attrStringFromHtml(s, tags: tags, small: small)
            result.append(attrString)
        }
    }
    return result
}
