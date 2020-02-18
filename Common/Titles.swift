//
//  titles.swift
//  Unbound Bible
//
//  Copyright © 2019 Vladimir Rybant. All rights reserved.
//

import Foundation

class ExternalTitles {
    private var database : FMDatabase?

    init(language: String) {
        let path = getFileName(language: language)
        database = FMDatabase(path: path)
        database!.open()
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
    
    func getData() -> [Title] {
        var data = [Title]()
        var k = 0
        
        let query = "SELECT * FROM Books"
        
        if let results = database!.executeQuery(query) {
            while results.next() {
                var t = Title()
                t.name = results.string(forColumn: "Name") ?? ""
                t.abbr = results.string(forColumn: "Abbreviation") ?? ""
                t.number = Int(results.int(forColumn: "Number"))
                
                if t.abbr.isEmpty { t.abbr = t.name }
                t.sorting = !isNewTestament(t.number) ? k : k + 100
                
                data.append(t)
                k += 1
            }
        }
        return data
    }
}
