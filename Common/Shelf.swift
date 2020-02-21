//
//  Shelf.swift
//  Unbound Bible
//
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import Foundation

var shelf = Shelf()

var bible: Bible? {
    return !shelf.isEmpty ? shelf.bibles[shelf.current] : nil
}

class Shelf {
    var bibles : [Bible] = []
    var current : Int = -1

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
            if let item = Bible(atPath: file) {
                bibles.append(item)
            }
        }
    }
    
    func setCurrent(_ index: Int) {
        if index >= self.bibles.count { return }
        current = index
        bibles[current].loadDatabase()
        if !bibles[current].goodLink(activeVerse) {
            activeVerse = bibles[current].firstVerse
        }
    }
    
    func setCurrent(_ fileName: String) {
        if bibles.isEmpty { return }
        for i in 0...bibles.count-1 {
            if bibles[i].fileName == fileName {
                setCurrent(i)
                return
            }
        }
        setCurrent(0)
    }
    
}
