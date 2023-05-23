//
//  Dictionary.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation
import GRDB

private protocol DictionaryAlias {
    var dictionary : String { get }
    var word : String { get }
    var data : String { get }
}

private struct UnboundAlias : DictionaryAlias {
    var dictionary = "Dictionary"
    var word = "Word"
    var data = "Data"
}

private struct MybibleAlias : DictionaryAlias {
    var dictionary = "dictionary"
    var word = "topic"
    var data = "definition"
}

class Dictionary: Module {
    private var z : DictionaryAlias = UnboundAlias()

    required init?(atPath: String) {
        super.init(atPath: atPath)
        if format == .mybible { z = MybibleAlias() }
        if connected && !tableExists(z.dictionary) { return nil }
    }
    
    func getStrongData(number: String) -> String? {
        var result : String?
        let query = "SELECT * FROM \(z.dictionary) WHERE \(z.word) = '\(number)' "
        try? database!.read { db in
            if let row = try Row.fetchOne(db, sql: query) {
                result = row[z.data] as String?
            }
        }
        return result
    }
    
    func getData(key: String) -> [String]? {
        var result = [String]()
        let query = "SELECT * FROM \(z.dictionary) WHERE \(z.word) = '\(key)' "
        try? database!.read { db in
            let rows = try Row.fetchCursor(db, sql: query)
            while let row = try rows.next() {
                let line = row[z.data] as String? ?? ""
                if !line.isEmpty { result.append(line) }
            }
        }
        return result.isEmpty ? nil : result
    }
    
}

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
        
        let symbol = Module.isNewTestament(verse.book) ? "G" : "H"
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
