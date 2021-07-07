//
//  Dictionary.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
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
        if connected && !database.tableExists(z.dictionary) { return nil }
    }
    
    func getStrongData(number: String) -> String? {
        let query = "select * from \(z.dictionary) where \(z.word) = \"\(number)\" "
        if let results = database.executeQuery(query) {
            if results.next() {
                return results.string(forColumn: z.data)
            }
        }
        return nil
    }
    
    func getData(key: String) -> [String]? {
        let query = "select * from \(z.dictionary) where \(z.word) = \"\(key)\" "
        
        var result = [String]()
        if let results = database.executeQuery(query) {
            while results.next() {
                if let line = results.string(forColumn: z.data) {
                    if !line.isEmpty { result.append(line) }
                }
            }
        }
        return result.isEmpty ? nil : result
    }
    
}

var dictionaries = [Dictionary](true)

extension Array where Element == Dictionary {
    
    init(_: Bool) {
        self.init()
        load()
        self.sort(by: {$0.name < $1.name} )
    }
    
    private mutating func load() {
        let files = databaseList.filter { $0.containsAny([".dct.",".dictionary."]) }
        for file in files {
            if let item = Dictionary(atPath: file) {
                self.append(item)
            }
        }
    }
    
    var embeddedOnly: Bool {
        for item in self {
            if !item.embedded { return false }
        }
        return true
    }
    
    private func strongByLanguage(_ language: String) -> Dictionary? {
        for dictionary in self {
            if !dictionary.strong { continue }
            if !dictionary.embedded { continue }
            if dictionary.language == language { return dictionary }
        }
        return nil
    }
    
    func getStrong(_ verse: Verse, language: String, number: String) -> String? {
        var number = number
        
        let symbol = isNewTestament(verse.book) ? "G" : "H"
        if !number.hasPrefix(symbol) { number =  symbol + number }

        if let dictionary = strongByLanguage(language) ?? strongByLanguage("en") {
            return dictionary.getStrongData(number: number)
        }
        return nil
    }
    
    mutating func deleteItem(_ item: Dictionary) {
        item.delete()
        self.removeAll(where: { $0 === item })
    }
    
}
