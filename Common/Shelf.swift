//
//  Shelf.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Foundation

var shelf = Shelf()

var currBible: Bible? {
    return shelf.currBible
}

class Shelf {
    var bibles : [Bible] = []
    var currBible : Bible? = nil

    init() {
        load()
        checkDoubleNames() // popUpButton can't has same names
        bibles.sort(by: {$0.name < $1.name} )
    }
    
    var isEmpty: Bool {
        return self.bibles.isEmpty
    }
    
    private func checkDoubleNames() {
        for item in bibles {
            for i in bibles {
                if i.fileName == item.fileName { continue }
                if i.name == item.name { i.name += "*" }
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
        for bible in bibles {
            if bible.name == name {
                bible.loadDatabase()
                if !bible.goodLink(currVerse) {
                    currVerse = bible.firstVerse
                }
                currBible = bible
                break
            }
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
