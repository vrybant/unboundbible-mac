//
//  Bible.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Foundation

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

struct Content {
    var verse : Verse
    var text : String
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
        if connected && !database.tableExists(z.bible) { connected = false }
        if !connected { return nil }
    }
    
    func loadUnboundDatabase() {
        let query = "SELECT * FROM " + z.books
        if let results = database.executeQuery(query) {
            while results.next() {
                let id = results.int(forColumn: z.number).int
                let name = results.string(forColumn: z.name) ?? ""
                let abbr = results.string(forColumn: z.abbr) ?? ""
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
        let query = "select distinct \(z.book) from \(z.bible)"
        if let results = database.executeQuery(query) {
            while results.next() {
                guard let value = results.string(forColumn: z.book) else { break }
                guard let number = Int(value) else { break }
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
        do {
            try database.executeUpdate("PRAGMA case_sensitive_like = \(value ? 1 : 0)", values: nil)
        } catch {
            //
        }
    }
    
    func chaptersCount(_ verse : Verse) -> Int {
        let id = encodeID(verse.book)
        let query = "select max(\(z.chapter)) as count from \(z.bible) where \(z.book) = \(id)"

        if let results = database.executeQuery(query) {
            if results.next() {
                return results.int(forColumn: "count").int
            }
        }
        return 0
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
        let id = encodeID(verse.book)
        let nt = Module.isNewTestament(verse.book)
        let query = "select * from \(z.bible) where \(z.book) = \(id) and \(z.chapter) = \(verse.chapter)"

        if let results = database.executeQuery(query) {
            var result = [String]()
            while results.next() {
                guard let line = results.string(forColumn: z.text) else { break }
                let text = preparation(line, format: format, nt: nt, purge: false)
                result.append(text)
            }
            if !result.isEmpty { return result }
        }
        return nil
    }
    
    func getRange(_ verse: Verse, prepare: Bool = true, purge: Bool = true) -> [String]? {
        let id = encodeID(verse.book)
        let nt = Module.isNewTestament(verse.book)
        let toVerse = verse.number + verse.count
        let query = "select * from \(z.bible) where \(z.book) = \(id) and \(z.chapter) = \(verse.chapter) "
            + "and \(z.verse) >= \(verse.number) and \(z.verse) < \(toVerse)"
        
        if let results = database.executeQuery(query) {
            var result = [String]()
            while results.next() {
                guard let line = results.string(forColumn: z.text) else { break }
                let text = prepare ? preparation(line, format: format, nt: nt, purge: purge) : line
                result.append(text)
            }
            if !result.isEmpty { return result }
        }
        return nil
    }
    
    private func extractFootnotes(_ string: String,_ marker: String) -> String {
        var string = string
        if format == .mysword {
            string = string.replace("<RF", with: "<f").replace("<Rf>", with: "</f>")
        }
        let list = xmlToList(string: string)
        var result = ""
        let tag = marker.hasPrefix("✻") ? "<f>" : "<f q=" + marker + ">"
        var l = false
        for item in list {
            if item == "</f>" { l = false; result += "\n" }
            if l { result += item }
            if item == tag { l = true }
        }
        return result
    }
     
    func getFootnote(_ verse : Verse, marker: String) -> String? {
        guard let range = getRange(verse, prepare: false) else { return nil }
        return extractFootnotes(range[0], marker)
    }
    
    func rankContents(contents: [Content]) -> [Content] {
        var result = [Content]()
        for book in books {
            for line in contents {
                if line.verse.book == book.number {
                    result.append(line)
                }
            }
        }
        return result
    }
    
    func search(string: String, options: SearchOption, range: SearchRange?) -> [Content]? {
        let list = string.components(separatedBy: CharacterSet.whitespaces).filter { !$0.isEmpty }
        var string = options.contains(.caseSensitive) ? string : string.lowercased().removeLeadingChars
        string = string.replace(" ", with: "%")
        
        let queryRange = range == nil ? "" : " and \(z.book) >= \(encodeID(range!.from)) and \(z.book) <= \(encodeID(range!.to))"
        let query = "select * from \(z.bible) where \(z.text) like \"%\(string)%\"" + queryRange
        
        setCaseSensitiveLike(options.contains(.caseSensitive))
        
        if let results = database.executeQuery(query) {
            var lines = [Content]()
            while results.next() {
                guard let book = results.string(forColumn: z.book) else { break }
                guard let chapter = results.string(forColumn: z.chapter) else { break }
                guard let number = results.string(forColumn: z.verse) else { break }
                guard let line = results.string(forColumn: z.text) else { break }
                
                let verse = Verse(book: decodeID(Int(book) ?? 0), chapter: Int(chapter) ?? 0, number: Int(number) ?? 0, count: 1)
                let nt = Module.isNewTestament(verse.book)
                var text = preparation(line, format: format, nt: nt)
                let content = Content(verse: verse, text: text)
                text = text.replace("<S>", with: " ").removeTags
                if text.containsEvery(list, options: options) { lines.append(content) }
            }
            if !lines.isEmpty {
                return rankContents(contents: lines)
            }
        }
        return nil
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
