//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

func attrStringFromTags(_ string: String, tags: Set<String>, jtag: Bool=false, small: Bool) -> NSAttributedString {
    let discount : CGFloat = small ? 2 : 1

    let     smallFont = Font(name: defaultFont.fontName,   size: defaultFont.pointSize - 2) ?? defaultFont
    let    italicFont = Font(name: "HelveticaNeue-Italic", size: defaultFont.pointSize - discount) ?? defaultFont
    let subscriptFont = Font(name: defaultFont.fontName,   size: defaultFont.pointSize - 5) ?? defaultFont
    let  footnoteFont = Font(name: defaultFont.fontName,   size: defaultFont.pointSize - 3) ?? defaultFont

    let s = NSMutableAttributedString(string: string, attributes: defaultAttributes)
    if small { s.addAttribute(.font, value: smallFont) }
    
    if jtag && tags.contains("<J>") { s.addAttribute(.foregroundColor, value: Color.systemRed) }
        
    if tags.contains("<m>") { s.addAttribute(.foregroundColor, value: Color.systemGray  ) }
    if tags.contains("<n>") { s.addAttribute(.foregroundColor, value: Color.systemGray  ) }
    if tags.contains("<v>") { s.addAttribute(.foregroundColor, value: Color.systemGray  ) }
    if tags.contains("<a>") { s.addAttribute(.foregroundColor, value: Color.systemGray  ) }
    if tags.contains("<S>") { s.addAttribute(.foregroundColor, value: Color.systemBrown ) }
    if tags.contains("<r>") { s.addAttribute(.foregroundColor, value: Color.systemRed   ) }
    if tags.contains("<f>") { s.addAttribute(.foregroundColor, value: Color.systemTeal  ) }
    if tags.contains("<l>") { s.addAttribute(.foregroundColor, value: Color.systemNavy  ) }

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

func parse(_ string: String, jtag: Bool = false, small: Bool = false) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()
    let string = string.replace("</p>", with: "\n") // TODO: move
    let list = xmlToTaggedStrings(string)
    for item in list {
        let attrString = attrStringFromTags(item.text, tags: item.tags, jtag: jtag, small: small)
        result.append(attrString)
    }
    return result
}

func attrStringFromHtml(_ string: String, tags: Set<String>, small: Bool) -> NSAttributedString {
    let discount : CGFloat = small ? 2 : 1
    
    let  smallFont = Font(name: defaultFont.fontName,  size: defaultFont.pointSize - 2) ?? defaultFont
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

func html(_ string: String, small: Bool = false) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()
    let string = htmlReplacement(string)
    let list = xmlToTaggedStrings(string)
    for item in list {
        let attrString = attrStringFromTags(item.text, tags: item.tags, small: small)
        result.append(attrString)
    }
    return result
}
