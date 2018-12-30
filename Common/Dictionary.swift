//
//  Dictionary.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

class TDictionary: Module {
    
    private var z = DictionaryAlias()
    
    override init(atPath: String) {
        super.init(atPath: atPath)
        if format == .mybible { z = mybibleDictionaryAlias }
        if connected && !database!.tableExists(z.dictionary) { connected = false }
//      if connected { print(atPath) }
    }
    
}
