//
//  ToolsExt.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

extension Tools {
    
    func get_Chapter() -> String {
        var result = ""
        if let text = currBible!.getChapter(currVerse) {
            if !text.isEmpty {
                for i in 0...text.count-1 {
                    result += " <l>" + String(i+1) + "</l> " + text[i] + "\n"
                }
            }
        }
        return result
    }
    
    func get_Search(string: String) -> (string: String, count: Int) {
        var result = ""
        var count = 0
        let target = searchOption.contains(.caseSensitive) ? string : string.lowercased()
        let searchList = target.components(separatedBy: " ")
        
        #if os(OSX)
            let range = currentSearchRange()
        #else
            let range : SearchRange? = nil
        #endif

        if let searchResult = currBible!.search(string: target, options: searchOption, range: range) {
            for content in searchResult {
                if let link = currBible!.verseToString(content.verse, full: true) {
                    let text = content.text.highlight(with: "<r>", target: searchList, options: searchOption)
                    result += "<l>\(link)</l> \(text)\n\n"
                }
            }
            count = searchResult.count
        }
        
        return (result, count)
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
                if let link = currBible!.verseToString(item, full: true) {
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
        return dictionaries.getStrong(currVerse, language: currBible!.language, number: number)
    }

    func get_Footnote(marker: String = "") -> String {
        if currBible!.format == .mybible {
            return commentaries.getFootnote(module: currBible!.fileName, verse: currVerse, marker: marker) ?? ""
        } else {
            return currBible!.getFootnote(currVerse, marker: marker) ?? ""
        }
    }

    func get_Verses(options: CopyOptions) -> NSAttributedString {
        guard let list = currBible!.getRange(currVerse) else { return NSAttributedString() }
        var quote = ""
        
        let full = !options.contains(.abbreviate)
        guard var link = currBible!.verseToString(currVerse, full: full) else { return NSAttributedString() }
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
        
        return parse(quote)
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
    
}