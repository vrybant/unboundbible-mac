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
    
    private func fileList(_ path: String) -> [String] {
        let extensions = [".unbound"]
        return getFileList(path).filter { $0.hasSuffix(extensions) }
    }
    
    private func load(path: String) {
        let files = fileList(path)
        for file in files {
            if !file.contains(".dct.") && !file.contains(".dictionary.") { continue }
            if let item = TDictionary(atPath: file) {
                items.append(item)
            }
        }
    }
    
}
