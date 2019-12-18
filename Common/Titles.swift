//
//  titles.swift
//  Unbound Bible
//
//  Copyright © 2019 Vladimir Rybant. All rights reserved.
//

import Foundation

struct Title {
    var name    = ""
    var abbr    = ""
    var number  = 0
    var sorting = 0
}

class Titles {
    private var database : FMDatabase?
    private var data = [Title]()

    init(language: String) {
        let path = getFileName(language: language)
        database = FMDatabase(path: path)
        database!.open()
        loadData()
    }
    
    private func getFileName(language: String) -> String {
        let path = resourcePath + slash + titleDirectory
        var result = path + slash + "en.sqlite"
        if language.isEmpty { return result }

        if let list = contentsOfDirectory(atPath: path) {
            for item in list {
                if item.lastPathComponent.hasPrefix(language) { result = item }
            }
        }
        return result
    }
    
    private func loadData() {
        var t = Title()
        var k = 0
        
        let query = "SELECT * FROM Books"
        
        if let results = database!.executeQuery(query) {
            while results.next() {
                t.name = results.string(forColumn: "Name") ?? ""
                t.abbr = results.string(forColumn: "Abbreviation") ?? ""
                t.number = Int(results.int(forColumn: "Number"))
                if t.abbr.isEmpty { t.abbr = t.name }
                t.sorting = !isNewTestament(t.number) ? k : k + 100
                data.append(t)
                k += 1
            }
        }
    }
    
    func getTitle(_ n: Int) -> Title? {
        for t in data {
            if t.number == n { return t }
        }
        return nil
    }
    
}

