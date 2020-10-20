//
//  data.swift
//  Unbound Bible
//
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import Foundation

let applicationName = "Unbound Bible"
let applicationVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
var applicationUpdate = false
var patreonVisited = false
let bibleDirectory = "bibles"

var recentList : [URL] = []

enum FileFormat {
    case unbound, mysword, mybible
}

struct Verse {
    var book    = 0
    var chapter = 0
    var number  = 0
    var count   = 0
}

var currVerse = Verse()

struct Book {
    var title   = ""
    var abbr    = ""
    var number  = 0
    var id      = 0
    var sorting = 0
}

struct Content {
    var verse = Verse()
    var text: String = ""
}

let myBibleArray : [Int] = [0,
        010,020,030,040,050,060,070,080,090,100,110,120,130,140,150,160,190,220,230,240,
        250,260,290,300,310,330,340,350,360,370,380,390,400,410,420,430,440,450,460,470,
        480,490,500,510,520,530,540,550,560,570,580,590,600,610,620,630,640,650,660,670,
        680,690,700,710,720,730,000,000,000,000,000,000,000,000,000,000,165,468,170,180,
        462,464,466,467,270,280,315,320]

let titlesArray : [String] = ["",
  "Genesis","Exodus","Leviticus","Numbers","Deuteronomy","Joshua","Judges","Ruth","1 Samuel","2 Samuel",
  "1 Kings","2 Kings","1 Chronicles","2 Chronicles","Ezra","Nehemiah","Esther","Job","Psalms","Proverbs",
  "Ecclesiastes","Song of Songs","Isaiah","Jeremiah","Lamentations","Ezekiel","Daniel","Hosea","Joel",
  "Amos","Obadiah","Jonah","Micah","Nahum","Habakkuk","Zephaniah","Haggai","Zechariah","Malachi","Matthew",
  "Mark","Luke","John","Acts","Romans","1 Corinthians","2 Corinthians","Galatians","Ephesians","Philippians",
  "Colossians","1 Thessalonians","2 Thessalonians","1 Timothy","2 Timothy","Titus","Philemon","Hebrews",
  "James","1 Peter","2 Peter","1 John","2 John","3 John","Jude","Revelation"
  ]

let abbrevArray : [String] = ["",
  "Gen.","Ex.","Lev.","Num.","Deut.","Josh.","Judg.","Ruth","1 Sam.","2 Sam.","1 Kin.","2 Kin.","1 Chr.",
  "2 Chr.","Ezra","Neh.","Esth.","Job","Ps.","Prov.","Eccl.","Song","Is.","Jer.","Lam.","Ezek.","Dan.",
  "Hos.","Joel","Amos","Obad.","Jon.","Mic.","Nah.","Hab.","Zeph.","Hag.","Zech.","Mal.","Matt.","Mark",
  "Luke","John","Acts","Rom.","1 Cor.","2 Cor.","Gal.","Eph.","Phil.","Col.","1 Thess.","2 Thess.","1 Tim.",
  "2 Tim.","Titus","Philem.","Heb.","James","1 Pet.","2 Pet.","1 John","2 John","3 John","Jude","Rev."
  ]

let bibleHubArray : [String] = ["",
        "genesis","exodus","leviticus","numbers","deuteronomy","joshua","judges","ruth","1_samuel","2_samuel",
        "1_kings","2_kings","1_chronicles","2_chronicles","ezra","nehemiah","esther","job","psalms","proverbs",
        "ecclesiastes","songs","isaiah","jeremiah","lamentations","ezekiel","daniel","hosea","joel","amos",
        "obadiah","jonah","micah","nahum","habakkuk","zephaniah","haggai","zechariah","malachi","matthew",
        "mark","luke","john","acts","romans","1_corinthians","2_corinthians","galatians","ephesians","philippians",
        "colossians","1_thessalonians","2_thessalonians","1_timothy","2_timothy","titus","philemon","hebrews",
        "james","1_peter","2_peter","1_john","2_john","3_john","jude","revelation"]

func unbound2mybible(_ id: Int) -> Int {
    let range = 1..<myBibleArray.count
    return range.contains(id) ? myBibleArray[id] : id
}

func mybible2unbound(_ id: Int) -> Int {
    return myBibleArray.firstIndex(of: id) ?? id
}

func isNewTestament(_ n: Int) -> Bool {
    return (n >= 40) && (n < 77)
}

var defaultBible: String {
    var result = ""
    switch languageCode {
    case "ru" : result = "rstw.bbl.unbound"
    case "uk" : result = "ubio.bbl.unbound"
    default   : result = "kjv.bbl.unbound"
    }
    return result
}

func databaseList() -> [String] {
    let extensions = [".unbound",".bblx",".bbli",".mybible",".SQLite3"]
    return contentsOfDirectory(url: dataUrl)?.filter { $0.hasSuffix(extensions) } ?? []
}

//********** RangeOption **********

enum RangeOption {
    case bible, oldTestament, newTestament, gospels, epistles, openedBook
}

//********** SearchOption **********

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

//********** CopyOptions **********

struct CopyOptions : OptionSet {
    let rawValue: Int
    static let  abbreviate = CopyOptions(rawValue: 1 << 0)
    static let   enumerate = CopyOptions(rawValue: 1 << 1)
    static let  guillemets = CopyOptions(rawValue: 1 << 2)
    static let parentheses = CopyOptions(rawValue: 1 << 3)
    static let  endinglink = CopyOptions(rawValue: 1 << 4)
}

var copyOptions: CopyOptions = []

//********** Defaults **********

var defaultCurrent : String?

func readDefaults() {
    let defaults = UserDefaults.standard
//      let domain = Bundle.main.bundleIdentifier!
//      defaults.removePersistentDomain(forName: domain) // debug
    defaults.set(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints​")

    applicationUpdate = defaults.string(forKey: "applicationVersion") != applicationVersion
    defaultCurrent = defaults.string(forKey: "current") ?? defaultBible

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
    
    patreonVisited = defaults.bool(forKey: "patreonVisited")
//  if applicationUpdate { patreonVisited = false }
}

func saveDefaults() {
    if shelf.isEmpty { return }
    let defaults = UserDefaults.standard
    defaults.set(applicationVersion,    forKey: "applicationVersion")
    defaults.set(currBible!.fileName,   forKey: "current")
    defaults.set(currVerse.book,        forKey: "verseBook")
    defaults.set(currVerse.chapter,     forKey: "verseChapter")
    defaults.set(currVerse.number,      forKey: "verseNumber")
    defaults.set(currVerse.count,       forKey: "verseCount")
    defaults.set(copyOptions.rawValue,  forKey: "copyOptions")
    defaults.set(defaultFont.fontName , forKey: "fontName")
    defaults.set(defaultFont.pointSize, forKey: "fontSize")
    defaults.set(recentList.bookmarks,  forKey: "bookmarks")
    defaults.set(patreonVisited,        forKey: "patreonVisited")
}

func readPrivates() {
    for item in shelf.bibles {
        item.compare = !UserDefaults.standard.bool(forKey: item.fileName)
    }
}

func savePrivates() {
    for item in shelf.bibles {
        UserDefaults.standard.set(!item.compare, forKey: item.fileName)
    }
}
