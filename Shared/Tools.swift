//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

var tools = Tools.shared
var currBible : Bible!

class Tools {
    static let shared = Tools()
    
    var bibles = [Bible](true)
    var commentaries = [Commentary](true)
    var dictionaries = [Dictionary](true)
    var references = [Reference](true)

    private let eol = cocoaApp ? "\n" : ""
    
    private init() {
        if bibles.isEmpty { return }
        setCurrBible(defaultCurrBible)
    }
    
    func setCurrBible(_ name: String?) {
        let name = name ?? bibles.getDefaultBible
        currBible = bibles[0]
        
        for bible in bibles {
            if bible.name == name {
                currBible = bible
                break
            }
        }
        
        currBible.loadDatabase()
        if !currBible.goodLink(currVerse) {
            currVerse = currBible.firstVerse
        }
    }

    func get_Chapter(book: Int, chapter: Int) -> [String] {
        var result = [String]()
        if let text = currBible.getChapter(book: book, chapter: chapter) {
            if !text.isEmpty {
                let space = cocoaApp ? " " : ""
                let dot = cocoaApp ? "" : "."
                for i in 0...text.count-1 {
                    let item = "\(space)<l>\(i+1)\(dot)</l> \(text[i])\(eol)"
                    result.append(item)
                }
            }
        }
        return result
    }
    
    func arrayToVerse(_ array: [String]) -> Verse? {
        var result = Verse()
        if array.count < 3 { return nil }
        result.book    = Int(array[0]) ?? 0
        result.chapter = Int(array[1]) ?? 0
        result.number  = Int(array[2]) ?? 0
        return result
    }
    
    func get_Search(string: String) -> (strings: [String], count: Int) {
        var result = [String]()
        var count = 0
        let target = searchOption.contains(.caseSensitive) ? string : string.lowercased()
        let searchList = target.components(separatedBy: " ")
        let range = currentSearchRange(range: rangeOption)
        
        if let searchResult = currBible.search(string: target, options: searchOption, range: range) {
            for s in searchResult {
                let array = s.components(separatedBy: "\0")
                if array.count < 4 { continue }
                guard let verse = arrayToVerse(array) else { continue }
                guard let link = currBible.verseToString(verse) else { continue }
                var text = array[3]
                text = text.highlight(with: "<r>", target: searchList, options: searchOption)
                let item = "<l>\(link)</l> \(text)\(eol)\(eol)"
                result.append(item)
            }
            count = searchResult.count
        }
        return (result, count)
    }

    func get_Compare() -> [String] {
        var result = [String]()
        
        for bible in bibles {
            if !bible.favorite { continue }
            if let list = bible.getRange(currVerse, purge: true) {
                let text = list.joined(separator: " ") + "\n\n"
                let item = "<l>\(bible.name)</l>\n\(text)"
                result.append(item)
            }
        }
        return result
    }

    func get_References() -> (string: String, info: String) {
        var result = ""
        var info = ""
        
        if let values = references.getData(currVerse, language: currBible.language) {
            info = values.info
            for item in values.data {
                if let link = currBible.verseToString(item) {
                    if let lines = currBible.getRange(item, purge: true) {
                        result += "<l>\(link)</l> "
                        result += lines.joined(separator: " ") + "\n\n"
                    }
                }
            }
        }
        return (result, info)
    }

    func get_Commentary() -> String {
        var result = ""
        for commentary in commentaries {
            if commentary.footnotes { continue }
            if let list = commentary.getData(currVerse) {
                let name = "<h>" + commentary.name + "</h>\n\n"
                result += name + list.joined(separator: " ") + "\n\n"
            }
        }
        return result
    }

    func get_Dictionary(key: String) -> String {
        var result = ""
        for dictionary in dictionaries {
            if dictionary.embedded { continue }
            if let list = dictionary.getData(key: key) {
                let name = "<h>" + dictionary.name + "</h>\n\n"
                result += name + list.joined(separator: " ") + "\n\n"
            }
        }
        return result
    }

    func get_Strong(number: String = "") -> String? {
        dictionaries.getStrong(currVerse, language: currBible.language, number: number)
    }

    func get_Footnote(marker: String = "") -> String {
        if currBible.format == .mybible {
            return commentaries.getFootnote(module: currBible.fileName, verse: currVerse, marker: marker) ?? ""
        } else {
            return currBible.getMyswordFootnote(currVerse, marker: marker) ?? ""
        }
    }

    func get_Verses(options: CopyOptions) -> String {
        guard let list = currBible.getRange(currVerse) else { return "" }
        var quote = ""
        
        let abbr = options.contains(.abbreviate)
        guard var link = currBible.verseToString(currVerse, abbr: abbr) else { return "" }
        link = "<l>" + link + "</l>"
        var number = currVerse.number
        var l = false
        
        for line in list {
            if options.contains(.enumerate) && list.count > 1 {
                if l || (!l && options.contains(.endinglink)) {
                    var n = String(number)
                    if options.contains(.parentheses) { n = "(" + n + ")" }
                    quote += n + " "
                }
            }

            quote += line + " "
            number += 1
            l = true
        }
        
        quote = quote.trimmed
        if options.contains(.guillemets ) { quote  = "«" + quote  + "»" }
        if options.contains(.parentheses) { link = "(" + link + ")" }
        quote = options.contains(.endinglink) ? quote + " " + link : link + " " + quote
        quote += "\n"
        
        return quote
    }
    
    func get_Modules() -> [Module] {
        var result : [Module] = []
        for bible      in bibles       { result.append(bible)      }
        for commentary in commentaries { result.append(commentary) }
        for dictionary in dictionaries { result.append(dictionary) }
        for reference  in references   { result.append(reference ) }
        return result
    }

    func deleteModule(module: Module) {
        if module is Bible      { bibles      .deleteItem(module as! Bible      ) }
        if module is Commentary { commentaries.deleteItem(module as! Commentary ) }
        if module is Dictionary { dictionaries.deleteItem(module as! Dictionary ) }
        if module is Reference  { references  .deleteItem(module as! Reference  ) }
    }

    func get_Shelf() -> [String] {
        var result : [String] = []
        for bible in bibles {
            let element = bible.name
            result.append(element)
        }
        return result
    }
    
    
    
    func get_Info(book: Int, chapter: Int) -> String {
        "Info \(book) \(chapter)"
    }
    
}
