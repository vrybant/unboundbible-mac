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
        let path = resourcePath + slash + titleDirectory
        var result = path + slash + "english.sqlite"
        if language.isEmpty { return result }

        if let list = getFileList(path) {
            for item in list {
                if item.lastPathComponent.hasPrefix(language) { result = item }
            }
        }
        return result
    }
    
    private func getTitleEx(_ n: Int, abbreviation: Bool) -> String {
        var name = ""
        var abbr = ""
        
        let query = "SELECT * FROM Books WHERE Number=\(n)"
        
        if let results = database!.executeQuery(query) {
            if results.next() {
                name = results.string(forColumn: "Name") ?? String(n)
                abbr = results.string(forColumn: "Abbreviation") ?? name
            }
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

