//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation
import SwiftUI

private func attrStringFromTags(_ string: String, tags: Set<String>, small: Bool) -> NSAttributedString {
    let discount : CGFloat = small ? 2 : 1

    let s = NSMutableAttributedString(string: string, attributes: defaultAttributes)

    if tags.contains("<m>") { s.addAttribute(.foregroundColor, value: Color.gray  ) }
    if tags.contains("<n>") { s.addAttribute(.foregroundColor, value: Color.gray  ) }
    if tags.contains("<v>") { s.addAttribute(.foregroundColor, value: Color.gray  ) }
    if tags.contains("<a>") { s.addAttribute(.foregroundColor, value: Color.gray  ) }
    if tags.contains("<J>") { s.addAttribute(.foregroundColor, value: Color.red   ) }
    if tags.contains("<S>") { s.addAttribute(.foregroundColor, value: Color.brown ) }
    if tags.contains("<r>") { s.addAttribute(.foregroundColor, value: Color.red   ) }
    if tags.contains("<f>") { s.addAttribute(.foregroundColor, value: Color.teal  ) }
    if tags.contains("<l>") { s.addAttribute(.foregroundColor, value: Color.gray  ) }

    if tags.intersection(["<S>","<m>","<f>"]) != [] {
        s.addAttribute(.baselineOffset, value: 5.0)
    }
    
    return s
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
