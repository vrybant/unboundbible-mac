//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation
import SwiftUI

func attrStringFromTags(_ string: String, tags: Set<String>, jtag: Bool=false, small: Bool) -> AttributedString {
    var s = AttributedString(string)

    if tags.contains("<m>") { s.foregroundColor = .gray  }
    if tags.contains("<n>") { s.foregroundColor = .gray  }
    if tags.contains("<v>") { s.foregroundColor = .gray  }
    if tags.contains("<a>") { s.foregroundColor = .gray  }
    if tags.contains("<S>") { s.foregroundColor = .brown }
    if tags.contains("<r>") { s.foregroundColor = .red   }
    if tags.contains("<f>") { s.foregroundColor = .teal  }
    if tags.contains("<l>") { s.foregroundColor = .gray  }

    if jtag {
        if tags.contains("<J>") { s.foregroundColor = .red }
    }
    
    if tags.intersection(["<S>","<m>","<f>"]) != [] {
        s.baselineOffset = 5.0
    }
    
    return s
}

func parse(_ string: String, jtag: Bool = false, small: Bool = false) -> AttributedString {
    var result = AttributedString()
    let string = string.replace("</p>", with: "\n") // TODO: move
    let list = xmlToTaggedStrings(string)
    for item in list {
        let attrString = attrStringFromTags(item.text, tags: item.tags, jtag: jtag, small: small)
        result.append(attrString)
    }
    return result
}
