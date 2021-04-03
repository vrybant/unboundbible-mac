//
//  Shelf.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Foundation

var shelf = Shelf()
var currBible : Bible? = nil

class Shelf {
    var bibles : [Bible] = []

    init() {
        load()
        checkDoubleNames() // popUpButton can't has same names
        bibles.sort(by: {$0.name < $1.name} )
    }
    
    var isEmpty: Bool {
        return self.bibles.isEmpty
    }
    
    private func checkDoubleNames() {
        for bible in bibles {
            for item in bibles {
                if item.fileName == bible.fileName { continue }
                if item.name == bible.name { item.name += "*" }
            }
        }
    }
    
    private func load() {
        let files = databaseList()
        for file in files {
            if file.contains(other: ".bbl.", options: []) || file.hasSuffix(".SQLite3") {
                if let item = Bible(atPath: file) {
                    bibles.append(item)
                }
            }
        }
    }
    
    func setCurrent(_ name: String) {
        if self.isEmpty { return }
        currBible = bibles[0]
        
        for bible in bibles {
            if bible.name == name {
                currBible = bible
                break
            }
        }
        
        currBible!.loadDatabase()
        if !currBible!.goodLink(currVerse) {
            currVerse = currBible!.firstVerse
        }
    }
    
    var getDefaultBible: String {
        var result = ""
        for bible in bibles {
            if bible.default_ {
                if bible.language == languageCode { return bible.name }
                if bible.language == "en" { result = bible.name }
            }
        }
        return result
    }
    
}
