//
//  Shelf.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Foundation

var bibles = Bibles()
var currBible : Bible? = nil

class Bibles {
    var items : [Bible] = []

    init() {
        load()
        checkDoubleNames() // popUpButton can't has same names
        items.sort(by: {$0.name < $1.name} )
    }
    
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    private func checkDoubleNames() {
        for bible in items {
            for item in items {
                if item.fileName == bible.fileName { continue }
                if item.name == bible.name { item.name += "*" }
            }
        }
    }
    
    private func load() {
        let files = databaseList
        for file in files {
            if file.contains(other: ".bbl.", options: []) || file.hasSuffix(".SQLite3") {
                if let item = Bible(atPath: file) {
                    items.append(item)
                }
            }
        }
    }
    
    func setCurrent(_ name: String) {
        if self.isEmpty { return }
        currBible = items[0]
        
        for bible in items {
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
        for bible in items {
            if bible.default_ {
                if bible.language == languageCode { return bible.name }
                if bible.language == "en" { result = bible.name }
            }
        }
        return result
    }
    
}
