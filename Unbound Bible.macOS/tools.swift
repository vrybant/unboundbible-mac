//
//  tools.swift
//  Unbound Bible
//
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import Cocoa

func loadChapter() {
    let attributedString = NSMutableAttributedString()
    if let text = bible!.getChapter(activeVerse) {
        if !text.isEmpty {
            for i in 0...text.count-1 {
                let string = " <l>" + String(i+1) + "</l> " + text[i] + "\n"
                attributedString.append( parse(string, jtag: true) )
            }
        }
    }
    rigthView.bibleTextView.baseWritingDirection = bible!.rightToLeft ? .rightToLeft : .leftToRight
    rigthView.bibleTextView.textStorage?.setAttributedString(attributedString)
}

func loadCompare() {
    if shelf.isEmpty { return }
    let link = bible!.verseToString(activeVerse, full: true) + "\n"
    let attrString = NSMutableAttributedString()
    attrString.append( parse(link) )
    
    for item in shelf.bibles {
        if !item.compare { continue }
        
        if let list = item.getRange(activeVerse, purge: true) {
            let text = list.joined(separator: " ") + "\n"
            let string = "\n<l>" + item.name + "</l>\n" + text
            attrString.append( parse(string) )
        }
    }

    selectTab("compare")
    rigthView.compareTextView.textStorage?.setAttributedString(attrString)
}

func loadXref() {
    if shelf.isEmpty { return }
    let link = bible!.verseToString(activeVerse, full: true) + "\n"
    let attrString = NSMutableAttributedString()
    attrString.append( parse(link) )

    for xref in xrefs.items {
        if let list = xref.getData(activeVerse) {
            
            let string = "\n</l>" + xref.name + "</l>\n\n"
            attrString.append( parse(string) )
            
            for item in list {
                let link = bible!.verseToString(item, full: true)
                let out = "<l>\(link)</l> "
                attrString.append( parse(out) )

                if let lines = bible!.getRange(item, purge: true) {
                    let text = lines.joined(separator: " ") + "\n\n"
                    attrString.append( parse(text) )
                }

                
            }
        }
    }
    
    selectTab("xref")
    rigthView.xrefTextView.textStorage?.setAttributedString(attrString)
}

func loadCommentary() {
    if shelf.isEmpty { return }
    let link = bible!.verseToString(activeVerse, full: true) + "\n"
    let attrString = NSMutableAttributedString()
    attrString.append( parse(link) )

    for item in commentaries.items {
        if item.footnotes { continue }
        
        if let list = item.getData(activeVerse) {
            let text = list.joined(separator: " ") + "\n"
            let string = "\n<l>" + item.name + "</l>\n\n"
            attrString.append( parse(string) )
            attrString.append( html(text) )
        }
    }
    
    selectTab("commentary")
    rigthView.commentaryTextView.textStorage?.setAttributedString(attrString)
}

func loadDictionary() {
    if shelf.isEmpty { return }
    let link = bible!.verseToString(activeVerse, full: true) + "\n"
    let attrString = NSMutableAttributedString()
    attrString.append( parse(link) )
    
    for item in dictionaries.items {
        if item.footnotes { continue }
        
//        if let list = item.getData(activeVerse) {
//            let text = list.joined(separator: " ") + "\n"
//            let string = "\n<l>" + item.name + "</l>\n\n"
//            attrString.append( parse(string) )
//            attrString.append( html(text) )
//        }
    }
    
    selectTab("dictionary")
    rigthView.compareTextView.textStorage?.setAttributedString(attrString)
}

func loadStrong(number: String = "") -> String {
    if let text = dictionaries.getStrong(activeVerse, language: bible!.language, number: number) { return text }
    return ""
}

func loadFootnote(marker: String = "") -> String {
    if bible!.format == .mybible {
        return commentaries.getFootnote(module: bible!.fileName, verse: activeVerse, marker: marker) ?? ""
    } else {
        return bible!.getFootnote(activeVerse, marker: marker) ?? ""
    }
}

func searchText(string: String) {
    let target = searchOption.contains(.caseSensitive) ? string : string.lowercased()
    let searchList = target.components(separatedBy: " ")
    let attributedString = NSMutableAttributedString()
    let range = currentSearchRange()
    
    if let searchResult = bible!.search(string: target, options: searchOption, range: range) {
        for content in searchResult {
            let link = bible!.verseToString(content.verse, full: true)
            let text = content.text.highlight(with: "<r>", target: searchList, options: searchOption)
            let out = "<l>\(link)</l> \(text)\n\n"
            attributedString.append(parse(out))
        }
        let message = NSLocalizedString("verses was found", comment: "")
        mainView.updateStatus("\(searchResult.count) \(message)")
    } else {
        let message = NSLocalizedString("You search for % produced no results.", comment: "")
        let out = "<i>\n \(message.replace("%", with: string.quoted)) </i>"
        attributedString.append(parse(out))
        mainView.updateStatus("")
    }
    
    rigthView.searchTextView.textStorage?.setAttributedString(attributedString)
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

func copyVerses(options: CopyOptions) -> NSAttributedString {
    if shelf.isEmpty { return NSAttributedString() }
    guard let list = bible!.getRange(activeVerse) else { return NSAttributedString() }
    var quote = ""
    
    let full = !options.contains(.abbreviate)
    var link = "<l>" + bible!.verseToString(activeVerse, full: full) + "</l>"
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
