//
//  Shelf.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

var activeVerse = Verse()

class Bible: Module {

    private var books  : [Book] = []
    private var titles : [String] = []
    private var z = StringAlias()
    
    var compare : Bool = true

    override init?(atPath: String) {
        super.init(atPath: atPath)
        if format == .mybible { z = mybibleStringAlias }
        if connected && !database!.tableExists(z.bible) { return nil }
    }
    
    var minBook : Int {
        var min = 0
        for book in books {
            if (book.number < min) || (min == 0) { min = book.number }
        }
        return min
    }
    
    func appendBook(id: Int) {
        var book = Book()
        let number = decodeID(id)
        book.number = number
        book.id = id
        book.sorting = sortingIndex(number)
        books.append(book)
    }
    
    func loadDatabase() {
        if loaded { return }
        let query = "select distinct \(z.book) from \(z.bible)"
        
        if let results = database!.executeQuery(query) {
            while results.next() {
                guard let stbook = results.string(forColumn: z.book) else { break }
                let id = stbook.int
                if id > 0 { appendBook(id: id) }
            }
            
            setTitles()
            titles = getTitles()
            firstVerse = Verse(book: minBook, chapter: 1, number: 1, count: 1)
            books.sort(by: {$0.sorting < $1.sorting} )
            loaded = true
        }
    }
    
    func setTitles() {
        if books.isEmpty { return }
        let titles = Titles(language: language)
        for i in 0...self.books.count-1 {
            books[i].title = titles.getTitle(books[i].number)
            books[i].abbr  = titles.getAbbr (books[i].number)
        }
    }
    
    func getTitles() -> [String] {
        var result = [String]()
        for book in books { result.append(book.title) }
        return result
    }
    
    func setCaseSensitiveLike(_ value: Bool) {
        do {
            try database?.executeUpdate("PRAGMA case_sensitive_like = \(value ? 1 : 0)", values: nil)
        } catch {
        }
    }
    
    func chapterCount(_ verse : Verse) -> Int {
        let id = encodeID(verse.book)
        let query = "select max(\(z.chapter)) as count from \(z.bible) where \(z.book) = \(id)"

        if let results = database!.executeQuery(query) {
            if results.next() {
                return Int( results.int(forColumn: "count") )
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

    func sortingIndex(_ number: Int) -> Int {
        if cyrillic(language: language) {
            return sortArrayRU.firstIndex(of: number) ?? 100
        } else {
            return sortArrayEN.firstIndex(of: number) ?? 100
        }
    }

    func getChapter(_ verse : Verse) -> [String]? {
        let id = encodeID(verse.book)
        let query = "select * from \(z.bible) where \(z.book) = \(id) and \(z.chapter) = \(verse.chapter)"

        if let results = database!.executeQuery(query) {
            var result = [String]()
            while results.next() {
                guard let line = results.string(forColumn: z.text) else { break }
                let text = prepare(line, format: format, purge: false)
                result.append(text)
            }
            if !result.isEmpty { return result }
        }
        return nil
    }
    
    func getRange(_ verse: Verse, preparation: Bool = true, purge: Bool = true) -> [String]? {
        let id = encodeID(verse.book)
        let toVerse = verse.number + verse.count
        let query = "select * from \(z.bible) where \(z.book) = \(id) and \(z.chapter) = \(verse.chapter) "
            + "and \(z.verse) >= \(verse.number) and \(z.verse) < \(toVerse)"
        
        if let results = database!.executeQuery(query) {
            var result = [String]()
            while results.next() {
                guard let line = results.string(forColumn: z.text) else { break }
                let text = preparation ? prepare(line, format: format, purge: purge) : line
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
        guard let range = getRange(verse, preparation: false) else { return nil }
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
        
        if let results = database!.executeQuery(query) {
            var lines = [Content]()
            while results.next() {
                guard let book = results.string(forColumn: z.book) else { break }
                guard let chapter = results.string(forColumn: z.chapter) else { break }
                guard let number = results.string(forColumn: z.verse) else { break }
                guard let line = results.string(forColumn: z.text) else { break }
                
                let verse = Verse(book: decodeID(book.int), chapter: chapter.int, number: number.int, count: 1)
                var text = prepare(line, format: format)
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
    
    func isNewTestament(_ n : Int) -> Bool {
        return (n >= 40) && (n <= 66)
    }
    
    func verseToString(_ verse: Verse, full: Bool) -> String {
        if let n = idxByNum(verse.book) {
            var name = full ? books[n].title : books[n].abbr
            if !name.contains(".") { name += " " }
            var result = name + String(verse.chapter) + ":" + String(verse.number)
            if verse.number != 0 && verse.count > 1 {
                result += "-" + String(verse.number + verse.count - 1)
            }
            return result
        }
        return "error"
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

var shelf = Shelf()

var bible: Bible? {
    return !shelf.isEmpty ? shelf.bibles[shelf.current] : nil
}

class Shelf {
    var bibles : [Bible] = []
    var current : Int = -1

    init() {
        load()
        checkDoubleNames() // popUpButton can't has same names
        bibles.sort(by: {$0.name < $1.name} )
    }
    
    var isEmpty: Bool {
        return self.bibles.isEmpty
    }
    
    private func checkDoubleNames() {
        for item in bibles {
            for i in bibles {
                if i.fileName == item.fileName { continue }
                if i.name == item.name { i.name += "*" }
            }
        }
    }
    
    private func load() {
        let files = databaseList()
        for file in files {
            if let item = Bible(atPath: file) {
                bibles.append(item)
            }
        }
    }
    
    func setCurrent(_ index: Int) {
        if index >= self.bibles.count { return }
        current = index
        bibles[current].loadDatabase()
        if !bibles[current].goodLink(activeVerse) {
            activeVerse = bibles[current].firstVerse
        }
    }
    
    func setCurrent(_ fileName: String) {
        if bibles.isEmpty { return }
        for i in 0...bibles.count-1 {
            if bibles[i].fileName == fileName {
                setCurrent(i)
                return
            }
        }
        setCurrent(0)
    }
    
}

