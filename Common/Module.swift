//
//  Module.swift
//  Unbound Bible
//
//  Created by Vladimir Rybant on 28/12/2018.
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

class Module {
    var database     : FMDatabase?
    var filePath     : String
    var fileName     : String
    var format       = FileFormat.unbound
    
    var name         : String = ""
    var abbreviation : String = ""
    var copyright    : String = ""
    var info         : String = ""
    var language     : String = ""
    var filetype     : String = ""
    
    var firstVerse   = Verse()
    var rightToLeft  : Bool = true
    var fontName     : String = ""
    var fontSize     : Int = 0
    
    var connected    : Bool = false
    var loaded       : Bool = false
    var strong       : Bool = false
    var footnotes    : Bool = false
    
    init?(atPath: String) {
        filePath = atPath
        fileName = atPath.lastPathComponent
        let ext = filePath.pathExtension 
        if ext == "mybible" || ext == "bbli" { format = .mysword }
        openDatabase()
        if !connected { return nil }
    }
    
    func encodeID(_ id: Int) -> Int {
        if format != .mybible { return id }
        if id > myBibleArray.count { return 0 }
        return myBibleArray[id]
    }
    
    func decodeID(_ id: Int) -> Int {
        if format != .mybible { return id }
        return myBibleArray.index(of: id) ?? id
    }
    
    func openDatabase() {
        database = FMDatabase(path: filePath)
        if !database!.open() { return }
        if database!.tableExists("info") { format = .mybible }
        
        if format == .unbound || format == .mysword {
            let query = "select * from Details"
            if let results = database!.executeQuery(query) {
                if results.next() {
                    if let value = results.string(forColumn: "Information" ) { info = value }
                    if let value = results.string(forColumn: "Description" ) { info = value }
                    if let value = results.string(forColumn: "Title"       ) { name = value } else { name = info }
                    if let value = results.string(forColumn: "Abbreviation") { abbreviation = value }
                    if let value = results.string(forColumn: "Copyright"   ) { copyright = value }
                    if let value = results.string(forColumn: "Language"    ) { language = value }
                    let value = results.bool(forColumn: "Strong") ; strong  = value

                    connected = true
                }
            }
        }

        if format == .mybible {
            let query = "select * from info"
            if let results = database!.executeQuery(query) {
                while results.next() {
                    guard let key = results.string(forColumn: "name") else { break }
                    guard let value = results.string(forColumn: "value") else { break }
                    
                    switch key {
                    case "description"   : name = value
                    case "detailed_info" : info = value
                    case "language"      : language = value
                    case "is_strong"     : strong = value == "true"
                    case "is_footnotes"  : footnotes = value == "true"
                    default : continue
                    }
                    connected = true
                }
            }
        }
        
        if connected {
            if name.isEmpty { name = fileName }
            language = language.lowercased()
            rightToLeft = getRightToLeft(language: language)
            info = info.removeTags
        }
    }
    
}

