//
//  ToolsExt.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation

class Tools: CustomTools {
    
    func get_Chapter() -> [String] {
        var result = [String]()
        if let text = currBible!.getChapter(currVerse) {
            if !text.isEmpty {
                for i in 0...text.count-1 {
                    let element = String(i+1) + ". " + parse(text[i])
                    result.append(element)
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
    
    func get_Search(string: String) -> [String] {
        var result = [String]()
        let target = searchOption.contains(.caseSensitive) ? string : string.lowercased()
        let searchList = target.components(separatedBy: " ")
        
        #if os(iOS)
            let range : SearchRange? = nil
        #endif

        if let searchResult = currBible!.search(string: target, options: searchOption, range: range) {
            for s in searchResult {
                let array = s.components(separatedBy: "\0")
                if array.count < 4 { continue }
                guard let verse = arrayToVerse(array) else { continue }
                guard let link = currBible!.verseToString(verse) else { continue }
                var text = array[3]
                text = text.highlight(with: "<r>", target: searchList, options: searchOption)
                let string = "<l>\(link)</l><br> \(text)"
                let element = parse(string)
                result.append(element)
            }
        }
        return result
    }

    func get_Compare() -> String {
        var result = ""
        
        for bible in bibles {
            if !bible.favorite { continue }
            if let list = bible.getRange(currVerse, purge: true) {
                let text = list.joined(separator: " ") + "\n\n"
                result += "<l>" + bible.name + "</l>\n" + text
            }
        }
        return result
    }

    func get_References() -> (string: String, info: String) {
        var result = ""
        var info = ""
        
        if let values = references.getData(currVerse, language: currBible!.language) {
            info = values.info
            for item in values.data {
                if let link = currBible!.verseToString(item) {
                    if let lines = currBible!.getRange(item, purge: true) {
                        result += "<l>\(link)</l> "
                        result += lines.joined(separator: " ") + "\n\n"
                    }
                }
            }
        }
        
        return (result, info)
    }

    func get_Commentary() -> NSAttributedString {
        let result = NSMutableAttributedString()

        for commentary in commentaries {
            if commentary.footnotes { continue }
            if let list = commentary.getData(currVerse) {
                var string = "<h>" + commentary.name + "</h>\n\n"
                string += list.joined(separator: " ") + "\n\n"
                result.append(html(string))
            }
        }
        
        return result
    }

    func get_Dictionary(key: String) -> NSAttributedString {
        let result = NSMutableAttributedString()
        for dictionary in dictionaries {
            if dictionary.embedded { continue }
            if let list = dictionary.getData(key: key) {
                var string = "<h>" + dictionary.name + "</h>\n\n"
                string += list.joined(separator: " ") + "\n\n"
                result.append(html(string))
            }
        }
        
        return result
    }

    func get_Strong(number: String = "") -> String? {
        dictionaries.getStrong(currVerse, language: currBible!.language, number: number)
    }

    func get_Footnote(marker: String = "") -> String {
        if currBible!.format == .mybible {
            return commentaries.getFootnote(module: currBible!.fileName, verse: currVerse, marker: marker) ?? ""
        } else {
            return currBible!.getMyswordFootnote(currVerse, marker: marker) ?? ""
        }
    }

    func get_Verses(options: CopyOptions) -> NSAttributedString {
        guard let list = currBible!.getRange(currVerse) else { return NSAttributedString() }
        var quote = ""
        
        let abbr = options.contains(.abbreviate)
        guard var link = currBible!.verseToString(currVerse, abbr: abbr) else { return NSAttributedString() }
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
        
        return parse(quote).attributed
    }
    
    func get_Shelf() -> [String] {
        var result : [String] = []
        for bible in bibles {
            let element = bible.name
            result.append(element)
        }
        return result
    }

}
