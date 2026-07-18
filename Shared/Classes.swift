//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

enum RangeOption {
    case bible, oldTestament, newTestament, gospels, epistles, openedBook
}

struct SearchRange {
    var from : Int
    var to : Int
}

struct SearchOption: OptionSet {
    let rawValue: Int
    static let caseSensitive = SearchOption(rawValue: 1 << 0)
    static let    wholeWords = SearchOption(rawValue: 1 << 1)
}

struct SearchItem: Identifiable {
    let link: String
    let text: String
    let id = UUID()
}

struct CopyOptions : OptionSet {
    let rawValue: Int
    static let  abbreviate = CopyOptions(rawValue: 1 << 0)
    static let   enumerate = CopyOptions(rawValue: 1 << 1)
    static let  guillemets = CopyOptions(rawValue: 1 << 2)
    static let parentheses = CopyOptions(rawValue: 1 << 3)
    static let  endinglink = CopyOptions(rawValue: 1 << 4)
}



