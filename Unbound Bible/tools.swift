//
//  tools.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

func loadChapter() {
    let text = bible.getChapter(activeVerse)
    let attributedString = NSMutableAttributedString()
    
    if text.count > 0 {
        for i in 0...text.count-1 {
            let string = " <l>" + String(i+1) + "</l> " + text[i] + "\n"
            attributedString.append( parse(string, jtag: true) )
        }
    }
    
    rigthView.bibleTextView.baseWritingDirection = bible.rightToLeft ? .rightToLeft : .leftToRight
    rigthView.bibleTextView.textStorage?.setAttributedString(attributedString)
}

func loadCompare() {  
    if shelf.bibles.isEmpty { return }
    
    let link = bible.verseToString(activeVerse, full: true) + "\n"
    let attrString = NSMutableAttributedString()
    attrString.append( parse(link, jtag: false) )
    
    for item in shelf.bibles {
        if !item.compare { continue }
        
        if let list = item.getRange(activeVerse) {
            let name = item.name
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
    
    if let searchResult = bible.search(string: string, options: searchOption, range: range) {
        for content in searchResult {
            let link = bible.verseToString(content.verse, full: true)
            let text = content.text.highlight(with: "<r>", target: searchList, options: searchOption)
            let out = "<l>\(link)</l> \(text)\n\n"
            attributedString.append(parse(out, jtag: false))
        }
        let message = NSLocalizedString("verses was found", comment: "")
        mainView.updateStatus("\(searchResult.count) \(message)")
    } else {
        let message = NSLocalizedString("You search for % produced no results.", comment: "")
        let out = "<i>\n \(message.replace("%", string.quoted)) </i>"
        attributedString.append(parse(out, jtag: false))
        mainView.updateStatus("")
    }
    
    rigthView.searchTextView.textStorage?.setAttributedString(attributedString)
}

func goToVerse(_ verse: Verse, select: Bool) {
    if shelf.bibles.isEmpty { return }
    if !bible.goodLink(verse) { return }
    if let index = bible.idxByNum(verse.book) {
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
    guard let list = bible.getRange(activeVerse) else { return NSMutableAttributedString() }
    var out = ""
    
    let full = !options.contains(.abbreviate)
    var link = "<l>" + bible.verseToString(activeVerse, full: full) + "</l>"
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
    
    if options.contains(.guillemets ) { out  = "«" + out  + "»" }
    if options.contains(.parentheses) { link = "(" + link + ")" }
    
    if options.contains(.endinglink) {
        out += " " + link
    } else {
        out = link + " " + out
    }
    out += "\n"
    
    return parse(out, jtag: false)
}
