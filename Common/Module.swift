//
//  Module.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Foundation

class Module {
    var database     : FMDatabase
    let filePath     : String
    let fileName     : String
    var format       = FileFormat.unbound
    
    var name         : String = ""
    var abbr         : String = ""
    var copyright    : String = ""
    var info         : String = ""
    var filetype     : String = ""
    
    var language     : String = "en"
    var rightToLeft  : Bool = true
    
    var connected    : Bool = false
    var loaded       : Bool = false
    var strong       : Bool = false
    var embedded     : Bool = false
    var footnotes    : Bool = false
    var interlinear  : Bool = false
    var default_     : Bool = false
    var accented     : Bool = false
    var favorite     : Bool = true

    init?(atPath: String) {
        filePath = atPath
        fileName = atPath.lastPathComponent
        let ext = filePath.pathExtension 
        if ext == "mybible" || ext == "bbli" { format = .mysword }
        database = FMDatabase(path: filePath)
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
        if !database.open() { return }
        if database.tableExists("info") { format = .mybible }
        
        if format == .unbound || format == .mysword {
            let query = "select * from Details"
            if let results = database.executeQuery(query) {
                if results.next() {
                    info      = results.string(forColumn: "Information" ) ?? ""
                    info      = results.string(forColumn: "Description" ) ?? info
                    name      = results.string(forColumn: "Title"       ) ?? info
                    abbr      = results.string(forColumn: "Abbreviation") ?? ""
                    copyright = results.string(forColumn: "Copyright"   ) ?? ""
                    language  = results.string(forColumn: "Language"    ) ?? ""
                    strong    = results.bool  (forColumn: "Strong"      )
                    embedded  = results.bool  (forColumn: "Embedded"    )
                    default_  = results.bool  (forColumn: "Default"     )
                    
                    connected = true
                }
            }
        }

        if format == .mybible {
            let query = "select * from info"
            if let results = database.executeQuery(query) {
                while results.next() {
                    guard let key = results.string(forColumn: "name") else { break }
                    guard let value = results.string(forColumn: "value") else { break }
                    
                    switch key {
                    case "description"    : name = value
                    case "detailed_info"  : info = value
                    case "language"       : language = value
                    case "strong_numbers" : strong = value == "true"
                    case "is_strong"      : strong = value == "true"
                    case "is_footnotes"   : footnotes = value == "true"
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
            accented = language == "ru"
        }
    }
   
    func closeDatabase() {
        database.close()
    }
        
    func delete() {
        closeDatabase()
        let url = dataUrl.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: url)
    }
    
}

