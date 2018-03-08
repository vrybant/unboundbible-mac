//
//  titles.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

class Titles {
    private var database : FMDatabase?

    init(language: String) {
        let path = getFileName(language: language)
        database = FMDatabase(path: path)
        database!.open()
    }
    
    private func getFileName(language: String) -> String {
        var file : String = "english.sqlite"
        let path : String = resourcePath + slash + titleDirectory
        
        if !language.isEmpty {
            let list = getFileList(path)
            
            for item in list {
                if item.hasPrefix(language) { file = item }
            }
        }
        
        return path + slash + file
    }
    
    private func getTitleEx(_ n: Int, abbreviation: Bool) -> String {
        var name = ""
        var abbr = ""
        
        let query = "SELECT * FROM Books WHERE Number=\(n)"
        
        if let results = try? database!.executeQuery(query, values: nil) {
            results.next()
            name = results.string(forColumn: "Name") ?? String(n)
            abbr = results.string(forColumn: "Abbreviation") ?? name
        }
        return abbreviation ? abbr : name
    }
    
    func getTitle(_ n: Int) -> String {
        return getTitleEx(n, abbreviation: false)
    }
    
    func getAbbr(_ n: Int) -> String {
        return getTitleEx(n, abbreviation: true)
    }
    
}

