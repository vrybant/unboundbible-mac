//
//  Bible.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation
import GRDB

struct Verse {
    var book    = 1
    var chapter = 1
    var number  = 1
    var count   = 1
}

var currVerse = Verse()

struct Book {
    var title   : String
    var abbr    : String
    var number  : Int
    var id      : Int
//  var sorting : Int
}

private protocol BibleAlias {
    var bible   : String { get }
    var book    : String { get }
    var chapter : String { get }
    var verse   : String { get }
    var text    : String { get }
    var books   : String { get }
    var number  : String { get }
    var name    : String { get }
    var abbr    : String { get }
}

private struct UnboundAlias : BibleAlias {
    var bible   = "Bible"
    var book    = "Book"
    var chapter = "Chapter"
    var verse   = "Verse"
    var text    = "Scripture"
    var books   = "Books"
    var number  = "Number"
    var name    = "Name"
    var abbr    = "Abbreviation"
}

private struct MybibleAlias : BibleAlias {
    var bible   = "verses"
    var book    = "book_number"
    var chapter = "chapter"
    var verse   = "verse"
    var text    = "text"
    var books   = "books"
    var number  = "book_number"
    var name    = "long_name"
    var abbr    = "short_name"
}

private let titlesArray : [String] = ["",
  "Genesis","Exodus","Leviticus","Numbers","Deuteronomy","Joshua","Judges","Ruth","1 Samuel","2 Samuel",
  "1 Kings","2 Kings","1 Chronicles","2 Chronicles","Ezra","Nehemiah","Esther","Job","Psalms","Proverbs",
  "Ecclesiastes","Song of Songs","Isaiah","Jeremiah","Lamentations","Ezekiel","Daniel","Hosea","Joel",
  "Amos","Obadiah","Jonah","Micah","Nahum","Habakkuk","Zephaniah","Haggai","Zechariah","Malachi","Matthew",
  "Mark","Luke","John","Acts","Romans","1 Corinthians","2 Corinthians","Galatians","Ephesians","Philippians",
  "Colossians","1 Thessalonians","2 Thessalonians","1 Timothy","2 Timothy","Titus","Philemon","Hebrews",
  "James","1 Peter","2 Peter","1 John","2 John","3 John","Jude","Revelation"
  ]

private let abbrevArray : [String] = ["",
  "Gen.","Ex.","Lev.","Num.","Deut.","Josh.","Judg.","Ruth","1 Sam.","2 Sam.","1 Kin.","2 Kin.","1 Chr.",
  "2 Chr.","Ezra","Neh.","Esth.","Job","Ps.","Prov.","Eccl.","Song","Is.","Jer.","Lam.","Ezek.","Dan.",
  "Hos.","Joel","Amos","Obad.","Jon.","Mic.","Nah.","Hab.","Zeph.","Hag.","Zech.","Mal.","Matt.","Mark",
  "Luke","John","Acts","Rom.","1 Cor.","2 Cor.","Gal.","Eph.","Phil.","Col.","1 Thess.","2 Thess.","1 Tim.",
  "2 Tim.","Titus","Philem.","Heb.","James","1 Pet.","2 Pet.","1 John","2 John","3 John","Jude","Rev."
  ]

class Bible: Module {
    private var books : [Book] = []
    private var z : BibleAlias = UnboundAlias()

    override init?(atPath: String) {
        super.init(atPath: atPath)
        if format == .mybible { z = MybibleAlias()  }
        if connected && !tableExists(z.bible) { connected = false }
        if !connected { return nil }
    }
    
    func loadUnboundDatabase() {
        try? database!.read { db in
            let query = "SELECT * FROM " + z.books
            let rows = try Row.fetchCursor(db, sql: query)

            while let row = try rows.next() {
                let id   = row[z.number] as Int?    ?? 0
                let name = row[z.name  ] as String? ?? ""
                let abbr = row[z.abbr  ] as String? ?? ""
                
                if id > 0 {
                    let number = decodeID(id)
                    let book = Book(title: name, abbr: abbr, number: number, id: id /* ,sorting: id */)
                    books.append(book)
                    loaded = true
                }
            }
        }
    }
    
    func loadMyswordDatabase() {
        try? database!.read { db in
            let query = "SELECT DISTINCT \(z.book) FROM \(z.bible)"
            let rows = try Row.fetchCursor(db, sql: query)

            while let row = try rows.next() {
                let number = row[z.book] as Int? ?? 0
                if number > 0 && number <= 66 {
                    let title = titlesArray[number]
                    let abbr = abbrevArray[number]
                    let book = Book(title: title, abbr: abbr, number: number, id: number)
                    books.append(book)
                    loaded = true
                }
            }
        }
    }

    func loadDatabase() {
        if loaded { return }
        if format == .mysword { loadMyswordDatabase() } else { loadUnboundDatabase() }
    }
    
    var firstVerse : Verse {
        return books.isEmpty ? Verse() : Verse(book: books[0].number, chapter: 1, number: 1, count: 1)
    }
    
    func getTitles() -> [String] {
        var result = [String]()
        for book in books { result.append(book.title) }
        return result
    }
    
    func setCaseSensitiveLike(_ value: Bool) {
        try? database!.write() { db in
            try db.execute(sql: "PRAGMA case_sensitive_like = \(value ? 1 : 0)")
        }
    }
    
    func chaptersCount(_ verse : Verse) -> Int {
        var result = 0
        let id = encodeID(verse.book)
        let query = "SELECT MAX(\(z.chapter)) AS count FROM \(z.bible) WHERE \(z.book) = \(id)"

        try? database!.read { db in
            if let row = try Row.fetchOne(db, sql: query) {
                result = row["count"] as Int? ?? 0
            }
        }
        return result
    }
    
    func idxByNum(_ n : Int) -> Int? {
        if !books.isEmpty {
            for result in 0...books.count-1 {
                if books[result].number == n { return result }
            }
        }
        return nil
    }
    
    func bookByName(_ s : String) -> Int? {
        for book in books {
            if book.title == s { return book.number }
        }
        return nil
    }

    func getChapter(_ verse : Verse) -> [String]? {
        var result = [String]()
        let id = encodeID(verse.book)
        let nt = Module.isNewTestament(verse.book)
        let query = "SELECT * FROM \(z.bible) WHERE \(z.book) = \(id) AND \(z.chapter) = \(verse.chapter)"
        
        try? database!.read { db in
            let rows = try Row.fetchCursor(db, sql: query)
            while let row = try rows.next() {
                guard let line = row[z.text] as String? else { break }
                let text = prepare(line, format: format, nt: nt, purge: false)
                result.append(text)
            }
        }
        
        return result.isEmpty ? nil : result
    }
    
    func getRange(_ verse: Verse, raw: Bool = false, purge: Bool = true) -> [String]? {
        var result = [String]()
        let id = encodeID(verse.book)
        let nt = Module.isNewTestament(verse.book)
        let toVerse = verse.number + verse.count
        let query = "SELECT * FROM \(z.bible) WHERE \(z.book) = \(id) AND \(z.chapter) = \(verse.chapter) "
            + "AND \(z.verse) >= \(verse.number) AND \(z.verse) < \(toVerse)"
        
        try? database!.read { db in
            let rows = try Row.fetchCursor(db, sql: query)
            while let row = try rows.next() {
                guard let line = row[z.text] as String? else { break }
                let text = raw ? line : prepare(line, format: format, nt: nt, purge: purge)
                result.append(text)
            }
        }
        return result.isEmpty ? nil : result
    }
    
    func getMyswordFootnote(_ verse : Verse, marker: String) -> String? {
        guard let range = getRange(verse, raw: true) else { return nil }
        let xml = xmlToList(string: range[0])
        let tag = marker.hasPrefix("✻") ? "<RF>" : "<RF q=" + marker + ">"
        var list: [String] = []
        var r = ""
        var l = false
        for item in xml {
            if item == "<Rf>" { l = false; list.append(r.trimmed); r = "";  }
            if l { r += item }
            if item == tag { l = true }
        }
        return list.joined(separator: "\n")
    }
    
    func sortContent(_ list: [String]) -> [String] {
        var result = [String]()
        for book in books {
            let prefix = String(book.number) + "\0"
            for s in list {
                if s.hasPrefix(prefix) {
                    result.append(s)
                }
            }
        }
        return result
    }
    
    func search(string: String, options: SearchOption, range: SearchRange?) -> [String]? {
        let list = string.components(separatedBy: CharacterSet.whitespaces).filter { !$0.isEmpty }
        var string = options.contains(.caseSensitive) ? string : string.lowercased().removeLeadingChars
        string = string.replace(" ", with: "%")
        
        let queryRange = range == nil ? "" : " AND \(z.book) >= \(encodeID(range!.from)) AND \(z.book) <= \(encodeID(range!.to))"
        let query = "SELECT * FROM \(z.bible) WHERE \(z.text) LIKE \'%\(string)%\'" + queryRange

        setCaseSensitiveLike(options.contains(.caseSensitive))
        var result = [String]()
        
        try? database!.read { db in
            let rows = try Row.fetchCursor(db, sql: query)
            while let row = try rows.next() {
                let id      = row[z.book   ] as Int?    ?? 0
                let chapter = row[z.chapter] as Int?    ?? 0
                let number  = row[z.verse  ] as Int?    ?? 0
                let data    = row[z.text   ] as String? ?? ""
                
                let book = decodeID(id)
                let nt = Module.isNewTestament(book)
                var text = prepare(data, format: format, nt: nt)
                let s = "\(book)\0\(chapter)\0\(number)\0\(text)"
                
                text = text.replace("<S>", with: " ").removeTags
                if text.containsEvery(list, options: options) { result.append(s) }
            }
        }
        return !result.isEmpty ? sortContent(result) : nil
    }
        
    func goodLink(_ verse: Verse) -> Bool {
        if let range = getRange(verse) {
            return !range.isEmpty
        } else {
            return false
        }
    }
    
    func verseToString(_ verse: Verse, full: Bool) -> String? {
        if let n = idxByNum(verse.book) {
            let title = full ? books[n].title : books[n].abbr
            let space = title.contains(".") ? "" : " "
            var result = title + space + String(verse.chapter) + ":" + String(verse.number)
            if verse.number != 0 && verse.count > 1 {
                result += "-" + String(verse.number + verse.count - 1)
            }
            return result
        }
        return nil
    }
    
    func stringToVerse(link: String) -> Verse? {
        if books.isEmpty { return nil }
        
        var verse = Verse()
        var title = ""
        var limit = 0
        
        for book in books {
            if link.hasPrefix(book.title) {
                title = book.title
                verse.book = book.number
                break
            }
            if link.hasPrefix(book.abbr) {
                title = book.abbr
                verse.book = book.number
                break
            }
        }

        if title == ""  { return nil }
        
        let index = link.index(link.startIndex, offsetBy: title.count)
        var string = link[index...].trimmed
        
        if let index = string.firstIndex(of: "-") {
            let subst = string[index...]
            let idx = subst.index(after: subst.startIndex)
            limit = subst[idx...].int
            string = string[..<index]
        }
        
        if let index = string.firstIndex(of: ":") {
            let chapter = string[..<index]
            let subst = string[index...]
            let idx = subst.index(after: subst.startIndex)
            let number = subst[idx...]
            
            verse.chapter = chapter.int
            verse.number = number.int
            if limit == 0 { verse.count = 1 } else { verse.count = limit - verse.number + 1 }
            if verse.book > 0 && verse.chapter > 0 && verse.number > 0 && verse.count > 0 {
                return verse
            }
        }
            
        return nil
    }
    
}

extension Array where Element == Bible {
    
    init(_: Bool) {
        self.init()
        load()
        checkDoubleNames() // popUpButton can't has same names
        self.sort(by: {$0.name < $1.name} )
    }

    private func checkDoubleNames() {
        for bible in self {
            for item in self {
                if item.fileName == bible.fileName { continue }
                if item.name == bible.name { item.name += "*" }
            }
        }
    }
    
    private mutating func load() {
        let files = databaseList
        for file in files {
            if file.contains(other: ".bbl.", options: []) || file.hasSuffix(".SQLite3") {
                if let item = Bible(atPath: file) {
                    self.append(item)
                }
            }
        }
    }
    
    func getNames() -> [String] {
        var result = [String]()
        for bible in self { result.append(bible.name) }
        return result
    }

    var getDefaultBible: String {
        var result = ""
        for bible in self {
            if bible.default_ {
                if bible.language == languageCode { return bible.name }
                if bible.language == "en" { result = bible.name }
            }
        }
        return result
    }
    
    mutating func deleteItem(_ item: Bible) {
        item.delete()
        self.removeAll(where: { $0 === item })
    }
}
