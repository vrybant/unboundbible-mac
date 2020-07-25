//
//  Module.swift
//  Unbound Bible
//
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import Foundation

class Module {
    var database     : FMDatabase?
    var filePath     : String
    var fileName     : String
    var format       = FileFormat.unbound
    
    var name         : String = ""
    var abbr         : String = ""
    var copyright    : String = ""
    var info         : String = ""
    var filetype     : String = ""
    
    var firstVerse   = Verse()
    var language     : String = "en"
    var rightToLeft  : Bool = true
    
    var connected    : Bool = false
    var loaded       : Bool = false
    var strong       : Bool = false
    var footnotes    : Bool = false
    var interlinear  : Bool = false
    var embtitles    : Bool = false
    
    init?(atPath: String) {
        filePath = atPath
        fileName = atPath.lastPathComponent
        let ext = filePath.pathExtension 
        if ext == "mybible" || ext == "bbli" { format = .mysword }
        openDatabase()
        if !connected { return nil }
    }
    
    func encodeID(_ id: Int) -> Int {
        return format == .mybible ? unbound2mybible(id) : id
    }
    
    func decodeID(_ id: Int) -> Int {
        return format == .mybible ? mybible2unbound(id) : id
    }
    
    func openDatabase() {
        database = FMDatabase(path: filePath)
        if !database!.open() { return }
        if database!.tableExists("info") { format = .mybible }
        
        if format == .unbound || format == .mysword {
            let query = "select * from Details"
            if let results = database!.executeQuery(query) {
                if results.next() {
                    info      = results.string(forColumn: "Information" ) ?? ""
                    info      = results.string(forColumn: "Description" ) ?? info
                    name      = results.string(forColumn: "Title"       ) ?? info
                    abbr      = results.string(forColumn: "Abbreviation") ?? ""
                    copyright = results.string(forColumn: "Copyright"   ) ?? ""
                    language  = results.string(forColumn: "Language"    ) ?? ""
                    strong    = results.bool(forColumn: "Strong")

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
            rightToLeft = getRightToLeft(language: language)
            info = info.removeTags
        }
    }
    
}

