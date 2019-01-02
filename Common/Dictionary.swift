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
//      if connected { print(atPath) }
    }
    
}

var dictionaries = Dictionaries()

class Dictionaries {
    
    var items = [TDictionary]()
    
    init() {
        load(path: dataPath)
        items.sort(by: {$0.name < $1.name} )
    }
    
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    private func load(path: String) {
        let files = getDatabaseList(path).filter { $0.containsAny([".dct.",".dictionary."]) }
        for file in files {
            if !file.hasSuffix(".unbound") { continue }
            if let item = TDictionary(atPath: file) {
                items.append(item)
            }
        }
    }
    
}
