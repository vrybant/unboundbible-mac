//
//  ToolsExt.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

extension Tools {
    
    func get_Chapter() -> [String] {
        var result = [String]()
        if let text = currBible!.getChapter(currVerse) {
            if !text.isEmpty {
                for i in 0...text.count-1 {
                    let line = String(i+1) + " " + text[i]
                    result.append(line)
                }
            }
        }
        return result
    }
    
}
