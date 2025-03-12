//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation
import SwiftUI

private func attrStringFromTags(_ string: String, tags: Set<String>, small: Bool) -> AttributedString {
    var s = AttributedString(string)

    if tags.contains("<m>") { s.foregroundColor = .gray  }
    if tags.contains("<n>") { s.foregroundColor = .gray  }
    if tags.contains("<v>") { s.foregroundColor = .gray  }
    if tags.contains("<a>") { s.foregroundColor = .gray  }
    if tags.contains("<J>") { s.foregroundColor = .red   }
    if tags.contains("<S>") { s.foregroundColor = .brown }
    if tags.contains("<r>") { s.foregroundColor = .red   }
    if tags.contains("<f>") { s.foregroundColor = .teal  }
    if tags.contains("<l>") { s.foregroundColor = .gray  }

    if tags.intersection(["<S>","<m>","<f>"]) != [] {
        s.baselineOffset = 5.0
    }
    
    return s
}

func parse(_ string: String, jtag: Bool = false, small: Bool = false) -> AttributedString {
    var result = AttributedString()
    // return AttributedString(string) // show tags

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
            if s.hasPrefix(" ") && result.description.hasSuffix(" ") { s = s.removeLeadingChar }
            let attrString = attrStringFromTags(s, tags: tags, small: small)
            result.append(attrString)
        }
    }
    return result
}
