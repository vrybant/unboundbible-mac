//
//  Tools.swift
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
    
}
