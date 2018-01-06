//
//  tools.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

func loadChapter() {
    let text = shelf.bibles[current].getChapter(activeVerse)
    let attributedString = NSMutableAttributedString()
    
    if text.count > 0 {
        for i in 0...text.count-1 {
            let string = " <l>" + String(i+1) + "</l> " + text[i] + "\n"
            attributedString.append( parse(string, jtag: true) )
        }
    }
    rigthView.bibleTextView.textStorage?.setAttributedString(attributedString)
}

func loadCompare() {  
    if shelf.bibles.isEmpty { return }
    
    let link = shelf.bibles[current].verseToString(activeVerse, full: true) + "\n"
    let attrString = NSMutableAttributedString()
    attrString.append( parse(link, jtag: false) )
    
    for bible in shelf.bibles {
        if !bible.compare { continue }
        
        if let list = bible.getRange(activeVerse) {
            let name = bible.name
            let text = list.joined(separator: " ") + "\n"
            let string = "\n<l>" + name + "</l>\n" + text
            attrString.append( parse(string, jtag: false) )
//          attrString.append( text.mutable(attributes: defaultAttribute) )
        }
    }  

    selectTab(at: .compare)
    rigthView.compareTextView.textStorage?.setAttributedString(attrString)
}

func searchText(string: String) {
    let string = searchOption.contains(.caseSensitive) ? string : string.lowercased()
    let searchList = string.components(separatedBy: " ")
    let attributedString = NSMutableAttributedString()
    let range = currentSearchRange()
    
    if let searchResult = shelf.bibles[current].search(string: string, options: searchOption, range: range) {
        for content in searchResult {
            let link = shelf.bibles[current].verseToString(content.verse, full: true)
            let text = content.text.highlight(with: "<r>", target: searchList, options: searchOption)
            let out = "<l>\(link)</l> \(text)\n\n"
            attributedString.append(parse(out, jtag: false))
        }
        mainView.updateStatus("\(searchResult.count) verses was found")
    } else {
        let out = "<i>\n You search for \"\(string)\" produced no results.</i>"
        attributedString.append(parse(out, jtag: false))
        mainView.updateStatus("")
    }
    
    rigthView.searchTextView.textStorage?.setAttributedString(attributedString)
}

func goToVerse(_ verse: Verse, select: Bool) {
    if shelf.bibles.isEmpty { return }
    if !shelf.bibles[current].goodLink(verse) { return }
    if let index = shelf.bibles[current].bookByNum(verse.book) {
        activeVerse = verse
        leftView.bookTableView.selectRow(index: index)
        leftView.chapterTableView.selectRow(index: verse.chapter - 1)
        if select {
            rigthView.bibleTextView.selectParagraph(number: verse.number)
        }
        selectTab(at: .bible)
    }
}

func copyVerses(options: CopyOptions) -> NSMutableAttributedString {
    guard let list = shelf.bibles[current].getRange(activeVerse) else { return NSMutableAttributedString() }
    var out = ""
    
    let full = !options.contains(.abbreviate)
    let link = "<l>" + shelf.bibles[current].verseToString(activeVerse, full: full) + "</l>"
    var n = activeVerse.number
    var l = false
    
    for line in list {
        let s = l ? " (\(n))" : ""
        if options.contains(.enumerate) { out += s }
        if l { out += " " }
        out += line
        n += 1
        l = true
    }
    
    if options.contains(.quotation) { out = "«" + out + "»" }
    
    if options.contains(.endinglink) {
        out += " " + link
    } else {
        out = link + " " + out
    }
    out += "\n"
    
    return parse(out, jtag: false)
}
