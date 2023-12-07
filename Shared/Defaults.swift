//
//  Defaults.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation

let applicationName = "Unbound Bible"
let applicationVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
var applicationUpdate = false
//var donateVisited = false
let bibleDirectory = "bibles"

#if os(OSX)
    let defaultFontSize = CGFloat(14)
#else
    let defaultFontSize = CGFloat(16)
#endif

var defaultFontName = "HelveticaNeue"
var defaultFont = Font.init(name: defaultFontName, size: defaultFontSize) ?? Font.systemFont(ofSize: defaultFontSize)

var defaultAttributes: [NSAttributedString.Key : Any] {
    [NSAttributedString.Key.foregroundColor: Color.labelColor, NSAttributedString.Key.font: defaultFont]
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

struct SearchRange {
    var from : Int
    var to : Int
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

    if let name = defaults.string(forKey: "fontName") {
        let size = defaults.cgfloat(forKey: "fontSize")
        if let font = Font(name: name, size: size) {
            defaultFont = font
        }
    }

    let value = defaults.integer(forKey: "copyOptions")
    copyOptions = CopyOptions(rawValue: value)

    if let bookmarks = defaults.object(forKey: "bookmarks") as? [Data] {
        recentList.append(bookmarks: bookmarks)
    }
    
//  donateVisited = defaults.bool(forKey: "donateVisited")
//  if applicationUpdate { donateVisited = false }
}

func saveDefaults() {
    if tools.bibles.isEmpty { return }
    let defaults = UserDefaults.standard
    defaults.set(applicationVersion,    forKey: "applicationVersion")
    defaults.set(currBible!.name,       forKey: "currentBible")
    defaults.set(currVerse.book,        forKey: "verseBook")
    defaults.set(currVerse.chapter,     forKey: "verseChapter")
    defaults.set(currVerse.number,      forKey: "verseNumber")
    defaults.set(currVerse.count,       forKey: "verseCount")
    defaults.set(copyOptions.rawValue,  forKey: "copyOptions")
    defaults.set(defaultFont.fontName , forKey: "fontName")
    defaults.set(defaultFont.pointSize, forKey: "fontSize")
    defaults.set(recentList.bookmarks,  forKey: "bookmarks")
//  defaults.set(donateVisited,         forKey: "donateVisited")
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
