//
//  kit.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Foundation

func loadChapter_() -> NSAttributedString {
    let attrString = NSMutableAttributedString()
    if let text = currBible!.getChapter(currVerse) {
        if !text.isEmpty {
            for i in 0...text.count-1 {
                let string = " <l>" + String(i+1) + "</l> " + text[i] + "\n"
                attrString.append( parse(string, jtag: true) )
            }
        }
    }
    return attrString
}

func loadCompare_() -> NSAttributedString {
    if bibles.isEmpty { return "".attributed }
    let link = currBible!.verseToString(currVerse, full: true) ?? ""
    let attrString = NSMutableAttributedString()
    attrString.append( parse("\(link)\n") )
    
    for bible in bibles {
        if !bible.favorite { continue }
        
        if let list = bible.getRange(currVerse, purge: true) {
            let text = list.joined(separator: " ") + "\n"
            let string = "\n<l>" + bible.name + "</l>\n" + text
            attrString.append( parse(string) )
        }
    }
    return attrString
}
