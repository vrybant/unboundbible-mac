//
//  kit.swift
//  Unbound Bible
//
//  Created by Vladimir Rybant on 20.12.2019.
//  Copyright © 2019 Vladimir Rybant. All rights reserved.
//

import Foundation

func loadChapter_() -> NSAttributedString {
    let attrString = NSMutableAttributedString()
    if let text = bible!.getChapter(activeVerse) {
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
    if shelf.isEmpty { return "".mutable() }
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
    return attrString
}
