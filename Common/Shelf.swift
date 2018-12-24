//
//  Shelf.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

var activeVerse = Verse()

class Module {
    var filePath     : String
    var fileName     : String
    var database     : FMDatabase?
    var format       = FileFormat.unbound
    var z            = StringAlias()
    var firstVerse   = Verse()
    
    var name         : String = ""
//  var native       : String = ""
    var abbreviation : String = ""
    var copyright    : String = ""
    var info         : String = ""
    var language     : String = ""
    var titleLang    : String = ""
    var filetype     : String = ""
    
    var rightToLeft  : Bool = true
    var compare      : Bool = true
    var fontName     : String = ""
    var fontSize     : Int = 0
    
    var connected    : Bool = false
    var loaded       : Bool = false
    var langEnable   : Bool = false
    
    init(atPath: String) {
        filePath = atPath
        fileName = atPath.lastPathComponent
        database = FMDatabase(path: filePath)
    }
}

class Bible: Module {
    var books        : [Book] = []
    var titles       : [String] = []

    override init(atPath: String) {
        super.init(atPath: atPath)
        openDatabase()
    }
    
    var minBook : Int {
        var min = 0
        for book in books {
            if (book.number < min) || (min == 0) { min = book.number }
        }
        return min
    }
    
    func openDatabase() {
        if !database!.open() { return }
        
        if fileName.hasSuffix(".SQLite3") {
            format = .mybible
            z = mybibleStringAlias
        }
        
        let query = "select * from \(z.details)"
        if let results = database!.executeQuery(query) {
            
            if format == .unbound {
                if results.next() {
                    if let value = results.string(forColumn: "Title"      ) { name = value }
                    if let value = results.string(forColumn: "Information") { info = value }
                    if let value = results.string(forColumn: "Description") { info = value }
                    if let value = results.string(forColumn: "Copyright"  ) { copyright = value }
                    if let value = results.string(forColumn: "Language"   ) { language  = value }
                }
            }
            
            if format == .mybible {
                while results.next() == true {
                    guard let key = results.string(forColumn: "name") else { break }
                    guard let value = results.string(forColumn: "value") else { break }

                    switch key {
                        case "description"   : name = value
                        case "language"      : language = value
                        case "detailed_info" : info = value
                        default : break
                    }
                }
            }
            
            if database!.tableExists(z.bible) { connected = true }
        }
        
        language = language.lowercased()
        if name.isEmpty { name = fileName }
        info = info.removeTags
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
            while results.next() == true {
                guard let stbook = results.string(forColumn: z.book) else { break }
                let id = stbook.int
                if id > 0 { appendBook(id: id) }
            }
            
            setTitles()
            titles = getTitles()
            firstVerse = Verse(book: minBook, chapter: 1, number: 1, count: 1)
            rightToLeft = getRightToLeft(language: language)
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

    func encodeID(_ id: Int) -> Int {
        if format != .mybible { return id }
        if id > myBibleArray.count { return 0 }
        return myBibleArray[id]
    }
    
    func decodeID(_ id: Int) -> Int {
        if format != .mybible { return id }
        return myBibleArray.index(of: id) ?? id
    }
    
    func sortingIndex(_ number: Int) -> Int {
        if orthodox(language: language) {
            return sortArrayRU.index(of: number) ?? 100
        } else {
            return sortArrayEN.index(of: number) ?? 100
        }
    }

    func getChapter(_ verse : Verse) -> [String]? {
        let id = encodeID(verse.book)
        let query = "select * from \(z.bible) where \(z.book) = \(id) and \(z.chapter) = \(verse.chapter)"

        if let results = database!.executeQuery(query) {
            var result = [String]()
            while results.next() == true {
                guard let line = results.string(forColumn: z.text) else { break }
                let text = prepare(line, format: format, purge: false)
                result.append(text)
            }
            if !result.isEmpty { return result }
        }
        return nil
    }
    
    func getRange(_ verse : Verse) -> [String]? {
        let id = encodeID(verse.book)
        let toVerse = verse.number + verse.count
        let query = "select * from \(z.bible) where \(z.book) = \(id) and \(z.chapter) = \(verse.chapter) "
            + "and \(z.verse) >= \(verse.number) and \(z.verse) < \(toVerse)"
        
        if let results = database!.executeQuery(query) {
            var result = [String]()
            while results.next() == true {
                guard let line = results.string(forColumn: z.text) else { break }
                let text = prepare(line, format: format)
                result.append(text)
            }
            if !result.isEmpty { return result }
        }
        return nil
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
            while results.next() == true {
                guard let book = results.string(forColumn: z.book) else { break }
                guard let chapter = results.string(forColumn: z.chapter) else { break }
                guard let number = results.string(forColumn: z.verse) else { break }
                guard let line = results.string(forColumn: z.text) else { break }
                
                let verse = Verse(book: decodeID(book.int), chapter: chapter.int, number: number.int, count: 1)
                let text = prepare(line, format: format)
                let content = Content(verse: verse, text: text)
                
                if text.removeTags.containsEvery(list: list, options: options) { lines.append(content) }
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
        
        if let index = string.index(of: "-") {
            let subst = string[index...]
            let idx = subst.index(after: subst.startIndex)
            limit = subst[idx...].int
            string = string[..<index]
        }
        
        if let index = string.index(of: ":") {
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
        addBibles(dataPath)
        bibles.sort(by: {$0.name < $1.name} )
    }
    
    var isEmpty: Bool {
        return self.bibles.isEmpty
    }
    
    func fileList(_ path: String) -> [String] {
        let extensions = [".unbound",".bblx",".bbli",".mybible",".SQLite3"]
        return getFileList(path).filter { $0.hasSuffix(extensions) }
    }
    
    private func checkDoubleName(newItem: Bible) {
        var l : Bool
        repeat {
            l = false
            for item in bibles {
                if item.name == newItem.name {
                    newItem.name = newItem.name + "*"
                    l = true
                }
            }
        } while l
    }
    
    func append(_ atPath: String) {
        let item = Bible(atPath: atPath)
        if !item.connected { return }
        checkDoubleName(newItem: item)
        bibles.append(item)
    }
    
    func addBibles(_ path: String) {
        let files = fileList(path)
        for file in files { append(file) }
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

