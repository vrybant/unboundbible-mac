//
//  Tools.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

var tools = Tools()
var currBible : Bible? = nil

class CustomTools {
    var bibles = [Bible](true)
    var commentaries = [Commentary](true)
    var dictionaries = [Dictionary](true)
    var references = [Reference](true)

    init() {
        if bibles.isEmpty { return }
        setCurrBible(defaultCurrBible)
    }
    
    func setCurrBible(_ name: String?) {
        let name = name ?? bibles.getDefaultBible
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

}
