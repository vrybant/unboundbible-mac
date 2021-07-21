//
//  Module.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Foundation

enum FileFormat {
    case unbound, mysword, mybible
}

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

    
    private let myBibleArray : [Int] = [0,
            010,020,030,040,050,060,070,080,090,100,110,120,130,140,150,160,190,220,230,240,
            250,260,290,300,310,330,340,350,360,370,380,390,400,410,420,430,440,450,460,470,
            480,490,500,510,520,530,540,550,560,570,580,590,600,610,620,630,640,650,660,670,
            680,690,700,710,720,730,000,000,000,000,000,000,000,000,000,000,165,468,170,180,
            462,464,466,467,270,280,315,320]
    
    init?(atPath: String) {
        filePath = atPath
        fileName = atPath.lastPathComponent
        let ext = filePath.pathExtension 
        if ext == "mybible" || ext == "bbli" { format = .mysword }
        if ext == "SQLite3" { format = .mybible }
        database = FMDatabase(path: filePath)
        openDatabase()
        if !connected { return nil }
    }

    private func unbound2mybible(_ id: Int) -> Int {
        let range = 1..<myBibleArray.count
        return range.contains(id) ? myBibleArray[id] : id
    }

    private func mybible2unbound(_ id: Int) -> Int {
        return myBibleArray.firstIndex(of: id) ?? id
    }

    func encodeID(_ id: Int) -> Int {
        return format == .mybible ? unbound2mybible(id) : id
    }
    
    func decodeID(_ id: Int) -> Int {
        return format == .mybible ? mybible2unbound(id) : id
    }
    
    static func isNewTestament(_ n: Int) -> Bool {
        return (n >= 40) && (n < 77)
    }

    func openDatabase() {
        if !database.open() { return }
        
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

