//
//  Dictionary.swift
//  Unbound Bible
//
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import Foundation

class Dictionary: Module {
    
    private struct Alias {
        var dictionary = "Dictionary"
        var word = "Word"
        var data = "Data"
    }

    private let mybibleAlias = Alias(
        dictionary : "dictionary",
        word : "topic",
        data : "definition"
    )

    private var z = Alias()
    
    override init?(atPath: String) {
        super.init(atPath: atPath)!
        if format == .mybible { z = mybibleAlias }
        if connected && !database!.tableExists(z.dictionary) { return nil }
    }
    
    func getStrongData(number: String) -> String? {
        let query = "select * from \(z.dictionary) where \(z.word) = \"\(number)\" "
        if let results = database!.executeQuery(query) {
            if results.next() {
                return results.string(forColumn: z.data)
            }
        }
        return nil
    }
    
    func getData(key: String) -> [String]? {
        let query = "select * from \(z.dictionary) where \(z.word) = \"\(key)\" "
        
        var result = [String]()
        if let results = database!.executeQuery(query) {
            while results.next() {
                if let line = results.string(forColumn: z.data) {
                    if !line.isEmpty { result.append(line) }
                }
            }
        }
        return result.isEmpty ? nil : result
    }
    
}

var dictionaries = Dictionaries()

class Dictionaries {
    
    var items = [Dictionary]()
    
    init() {
        load()
        items.sort(by: {$0.name < $1.name} )
    }
    
    private func load() {
        let files = databaseList().filter { $0.containsAny([".dct.",".dictionary."]) }
        for file in files {
            if let item = Dictionary(atPath: file) {
                items.append(item)
            }
        }
    }
    
    var isEmpty: Bool {
        for item in items {
            if !item.embedded { return true }
        }
        return false
    }
    
    private func strongByLanguage(_ language: String) -> Int? {
        for i in 0...items.count-1 {
            if !items[i].strong { continue }
            if !items[i].embedded { continue }
            if items[i].language == language { return i }
        }
        return nil
    }
    
    func getStrong(_ verse: Verse, language: String, number: String) -> String? {
        var number = number
        
        let symbol = isNewTestament(verse.book) ? "G" : "H"
        if !number.hasPrefix(symbol) { number =  symbol + number }

        if let index = strongByLanguage(language) ?? strongByLanguage("en") {
            return items[index].getStrongData(number: number)
        }
        return nil
    }
    
}
