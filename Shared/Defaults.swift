//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

#if !COCOA
    import SwiftUI
#endif

let userDefaults = UserDefaults.standard
let applicationName = "Unbound Bible"
let applicationVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
var applicationUpdate = userDefaults.string(forKey: "applicationVersion") != applicationVersion
var defaultCurrBible : String? = userDefaults.string(forKey: "currentBible")
var rangeOption : RangeOption = RangeOption.bible
var searchOption : SearchOption = []
var copyOptions: CopyOptions = userDefaults.copyOption(forKey: "copyOptions")
let bibleDirectory = "bibles"
let databaseExtensions = [".unbound",".bblx",".bbli",".mybible",".SQLite3"]

#if COCOA
var systemFont = Font.systemFont(ofSize: 14)
var defaultFont = userDefaults.font(forKey: "fontName", forSize: "fontSize") ?? systemFont

var defaultAttributes: [NSAttributedString.Key : Any] {
    [NSAttributedString.Key.font: defaultFont, NSAttributedString.Key.foregroundColor: Color.labelColor]
}
var recentList : [URL] = userDefaults.urlList(forKey: "recents")
#endif

let bibleHubArray : [String] = ["",
    "genesis","exodus","leviticus","numbers","deuteronomy","joshua","judges","ruth","1_samuel","2_samuel",
    "1_kings","2_kings","1_chronicles","2_chronicles","ezra","nehemiah","esther","job","psalms","proverbs",
    "ecclesiastes","songs","isaiah","jeremiah","lamentations","ezekiel","daniel","hosea","joel","amos",
    "obadiah","jonah","micah","nahum","habakkuk","zephaniah","haggai","zechariah","malachi","matthew",
    "mark","luke","john","acts","romans","1_corinthians","2_corinthians","galatians","ephesians","philippians",
    "colossians","1_thessalonians","2_thessalonians","1_timothy","2_timothy","titus","philemon","hebrews",
    "james","1_peter","2_peter","1_john","2_john","3_john","jude","revelation"]

var databaseList : [String] {
    contentsOfDirectory(url: dataUrl)?.filter { $0.hasSuffix(databaseExtensions) } ?? []
}

var unboundBiblesList : [String] {
    contentsOfDirectory(url: dataUrl)?.filter { $0.hasSuffix(".bbl.unbound") } ?? []
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

func cleanDeaults() {
    let domain = Bundle.main.bundleIdentifier!
    userDefaults.removePersistentDomain(forName: domain)
}

func saveDefaults() {
    if tools.bibles.isEmpty { return }

    userDefaults.set(applicationVersion, forKey: "applicationVersion")
    userDefaults.set(currBible.name,     forKey: "currentBible")
    userDefaults.set(currVerse,          forKey: "currVerse")
    userDefaults.set(copyOptions,        forKey: "copyOptions")

    #if COCOA
    userDefaults.set(recentList, forKey: "recents")
    userDefaults.set(defaultFont, forKey: "fontName", forSize: "fontSize")
    #endif
}

func readPrivates() {
    for bible in tools.bibles {
        bible.favorite = !userDefaults.bool(forKey: bible.fileName)
    }
}

func savePrivates() {
    for bible in tools.bibles {
        userDefaults.set(!bible.favorite, forKey: bible.fileName)
    }
}
