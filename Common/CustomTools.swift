//
//  Tools.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

var tools = Tools()
var currBible : Bible? = nil

class Tools {
    
    var bibles = [Bible](true)
    var commentaries = [Commentary](true)
    var dictionaries = [Dictionary](true)
    var references = [Reference](true)
    
    func setCurrBible(_ name: String) {
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
