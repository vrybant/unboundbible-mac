//
//  Dictionary.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

class TDictionary: Module {
    
    private var z = DictionaryAlias()
    
    override init?(atPath: String) {
        super.init(atPath: atPath)!
        if format == .mybible { z = mybibleDictionaryAlias }
        if connected && !database!.tableExists(z.dictionary) { return nil }
    }
    
    func getData(number: String) -> String? {
        let query = "select * from \(z.dictionary) where \(z.word) = \"\(number)\" "
        if let results = database!.executeQuery(query) {
            if results.next() {
                return results.string(forColumn: z.data)
            }
        }
        return nil
    }
    
}

var dictionaries = Dictionaries()

class Dictionaries {
    
    var items = [TDictionary]()
    
    init() {
        load()
        items.sort(by: {$0.name < $1.name} )
    }
    
    private func load() {
        let files = databaseList().filter { $0.containsAny([".dct.",".dictionary."]) }
        for file in files {
            if !file.hasSuffix(".unbound") { continue }
            if let item = TDictionary(atPath: file) {
                items.append(item)
            }
        }
    }
    
    func getStrong(_ verse: Verse, language: String, number: String) -> String? {
        var number = number
        let filename = language.hasPrefix("ru") ? "strongru.dct.unbound" : "strong.dct.unbound"
        
        let letter = isNewTestament(verse.book) ? "G" : "H"
        if !number.hasPrefix(letter) { number =  letter + number }

        for item in items {
            if !item.strong { continue }
            if item.fileName != filename { continue }
            return item.getData(number: number)
        }
        return nil
    }
    
}
