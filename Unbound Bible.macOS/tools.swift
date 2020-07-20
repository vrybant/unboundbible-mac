//
//  tools.swift
//  Unbound Bible
//
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import Cocoa

func get_Chapter() -> String {
    var result = ""
    if let text = bible!.getChapter(activeVerse) {
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
    let range = currentSearchRange()
    
    if let searchResult = bible!.search(string: target, options: searchOption, range: range) {
        for content in searchResult {
            if let link = bible!.verseToString(content.verse, full: true) {
                let text = content.text.highlight(with: "<r>", target: searchList, options: searchOption)
                result += "<l>\(link)</l> \(text)\n\n"
            }
        }
        count = searchResult.count
    }
        
    return (result, count)
}

func get_Compare() -> String {
    if shelf.isEmpty { return "" }
    var result = ""
    
    for item in shelf.bibles {
        if !item.compare { continue }
        if let list = item.getRange(activeVerse, purge: true) {
            let text = list.joined(separator: " ") + "\n\n"
            result += "<l>" + item.name + "</l>\n" + text
        }
    }
    return result
}

func get_Xref() -> String {
    var result = ""
    
    if let list = references.getData(activeVerse, language: bible!.language) {
        for item in list {
            if let link = bible!.verseToString(item, full: true) {
                if let lines = bible!.getRange(item, purge: true) {
                    result += "<l>\(link)</l> "
                    result += lines.joined(separator: " ") + "\n\n"
                }
            }
        }
    }
    
    return result
}

func get_Commentary() -> NSAttributedString {
    let result = NSMutableAttributedString()
    if shelf.isEmpty { return result }

    for item in commentaries.items {
        if item.footnotes { continue }
        if let list = item.getData(activeVerse) {
            let string = "<l>" + item.name + "</l>\n\n"
            let text = list.joined(separator: " ") + "\n\n"
            result.append( parse(string) )
            result.append( html(text) )
        }
    }
    
    return result
}

func get_Dictionary(key: String) -> NSAttributedString {
    let result = NSMutableAttributedString()
    if shelf.isEmpty { return result }
    
    for item in dictionaries.items {
        if item.footnotes { continue }
        if let list = item.getData(key: key) {
            let string = "<l>" + item.name + "</l>\n\n"
            let text = list.joined(separator: " ") + "\n\n"
            result.append( parse(string) )
            result.append( html(text) )
        }
    }
    
    return result
}

func get_Strong(number: String = "") -> String {
    if let text = dictionaries.getStrong(activeVerse, language: bible!.language, number: number) { return text }
    return ""
}

func get_Footnote(marker: String = "") -> String {
    if bible!.format == .mybible {
        return commentaries.getFootnote(module: bible!.fileName, verse: activeVerse, marker: marker) ?? ""
    } else {
        return bible!.getFootnote(activeVerse, marker: marker) ?? ""
    }
}

func get_Verses(options: CopyOptions) -> NSAttributedString {
    if shelf.isEmpty { return NSAttributedString() }
    guard let list = bible!.getRange(activeVerse) else { return NSAttributedString() }
    var quote = ""
    
    let full = !options.contains(.abbreviate)
    guard var link = bible!.verseToString(activeVerse, full: full) else { return NSAttributedString() }
    link = "<l>" + link + "</l>"
    var number = activeVerse.number
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

func goToVerse(_ verse: Verse, select: Bool) {
    if !bible!.goodLink(verse) { return }
    if let index = bible!.idxByNum(verse.book) {
        activeVerse = verse
        leftView.bookTableView.selectRow(index: index)
        leftView.chapterTableView.selectRow(index: verse.chapter - 1)
        if select {
            rigthView.bibleTextView.selectParagraph(number: verse.number)
        }
        selectTab("bible")
    }
}
