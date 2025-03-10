//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

#if !COCOA
    import SwiftUI
#endif

let applicationName = "Unbound Bible"
let applicationVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
var applicationUpdate = false
let bibleDirectory = "bibles"

#if COCOA
    let cocoaApp = true
    let defaultFontSize = CGFloat(14)
    var defaultFontName = "HelveticaNeue"
    var defaultFont = Font.init(name: defaultFontName, size: defaultFontSize) ?? Font.systemFont(ofSize: defaultFontSize)
#else
    let cocoaApp = false
    let defaultFontSize = CGFloat(18)
    let defaultFont = Font.system(size: defaultFontSize)
#endif

var defaultAttributes: [NSAttributedString.Key : Any] {
    [NSAttributedString.Key.font: defaultFont, NSAttributedString.Key.foregroundColor: Color.labelColor]
}

var recentList : [URL] = []

let bibleHubArray : [String] = ["",
        "genesis","exodus","leviticus","numbers","deuteronomy","joshua","judges","ruth","1_samuel","2_samuel",
        "1_kings","2_kings","1_chronicles","2_chronicles","ezra","nehemiah","esther","job","psalms","proverbs",
        "ecclesiastes","songs","isaiah","jeremiah","lamentations","ezekiel","daniel","hosea","joel","amos",
        "obadiah","jonah","micah","nahum","habakkuk","zephaniah","haggai","zechariah","malachi","matthew",
        "mark","luke","john","acts","romans","1_corinthians","2_corinthians","galatians","ephesians","philippians",
        "colossians","1_thessalonians","2_thessalonians","1_timothy","2_timothy","titus","philemon","hebrews",
        "james","1_peter","2_peter","1_john","2_john","3_john","jude","revelation"]

var databaseList : [String] {
    let extensions = [".unbound",".bblx",".bbli",".mybible",".SQLite3"]
    return contentsOfDirectory(url: dataUrl)?.filter { $0.hasSuffix(extensions) } ?? []
}

var unboundBiblesList : [String] {
    contentsOfDirectory(url: dataUrl)?.filter { $0.hasSuffix(".bbl.unbound") } ?? []
}

enum RangeOption {
    case bible, oldTestament, newTestament, gospels, epistles, openedBook
}

var rangeOption : RangeOption = RangeOption.bible

struct SearchRange {
    var from : Int
    var to : Int
}

func currentSearchRange(range: RangeOption) -> SearchRange? {
    switch range {
        case .bible        : return nil
        case .oldTestament : return SearchRange(from:  1, to: 39)
        case .newTestament : return SearchRange(from: 40, to: 66)
        case .gospels      : return SearchRange(from: 40, to: 43)
        case .epistles     : return SearchRange(from: 45, to: 65)
        case .openedBook   : return SearchRange(from:  currVerse.book, to:  currVerse.book)
    }
}

struct SearchOption: OptionSet {
    let rawValue: Int
    static let caseSensitive = SearchOption(rawValue: 1 << 0)
    static let    wholeWords = SearchOption(rawValue: 1 << 1)
}

var searchOption : SearchOption = []

struct CopyOptions : OptionSet {
    let rawValue: Int
    static let  abbreviate = CopyOptions(rawValue: 1 << 0)
    static let   enumerate = CopyOptions(rawValue: 1 << 1)
    static let  guillemets = CopyOptions(rawValue: 1 << 2)
    static let parentheses = CopyOptions(rawValue: 1 << 3)
    static let  endinglink = CopyOptions(rawValue: 1 << 4)
}

var copyOptions: CopyOptions = []

var defaultCurrBible : String?

func readDefaults() {
    let defaults = UserDefaults.standard
//      let domain = Bundle.main.bundleIdentifier!
//      defaults.removePersistentDomain(forName: domain) // debug
    defaults.set(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints​")

    applicationUpdate = defaults.string(forKey: "applicationVersion") != applicationVersion
    defaultCurrBible  = defaults.string(forKey: "currentBible")

    currVerse.book    = defaults.integer(forKey: "verseBook")
    currVerse.chapter = defaults.integer(forKey: "verseChapter")
    currVerse.number  = defaults.integer(forKey: "verseNumber")
    currVerse.count   = defaults.integer(forKey: "verseCount")

    let value = defaults.integer(forKey: "copyOptions")
    copyOptions = CopyOptions(rawValue: value)

    if let bookmarks = defaults.object(forKey: "bookmarks") as? [Data] {
        recentList.append(bookmarks: bookmarks)
    }
    
    #if COCOA
    if let name = defaults.string(forKey: "fontName") {
        let size = defaults.cgfloat(forKey: "fontSize")
        if let font = Font(name: name, size: size) {
            defaultFont = font
        }
    }
    #endif
}

func saveDefaults() {
    if tools.bibles.isEmpty { return }
    let defaults = UserDefaults.standard
    defaults.set(applicationVersion,    forKey: "applicationVersion")
    defaults.set(currBible.name,        forKey: "currentBible")
    defaults.set(currVerse.book,        forKey: "verseBook")
    defaults.set(currVerse.chapter,     forKey: "verseChapter")
    defaults.set(currVerse.number,      forKey: "verseNumber")
    defaults.set(currVerse.count,       forKey: "verseCount")
    defaults.set(copyOptions.rawValue,  forKey: "copyOptions")
    defaults.set(recentList.bookmarks,  forKey: "bookmarks")

    #if COCOA
        defaults.set(defaultFont.fontName , forKey: "fontName")
        defaults.set(defaultFont.pointSize, forKey: "fontSize")
    #endif
}

func readPrivates() {
    for bible in tools.bibles {
        bible.favorite = !UserDefaults.standard.bool(forKey: bible.fileName)
    }
}

func savePrivates() {
    for bible in tools.bibles {
        UserDefaults.standard.set(!bible.favorite, forKey: bible.fileName)
    }
}
