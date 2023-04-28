//
//  Module.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Foundation
import GRDB

enum FileFormat {
    case unbound, mysword, mybible
}

class Module {
    var database     : DatabaseQueue?
    
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
        database = try? DatabaseQueue(path: filePath)
        if database != nil { openDatabase() }
        if !connected { return nil }
    }

    func openDatabase() {
        try? database!.read { db in
            
            if format == .unbound || format == .mysword {
                let query = "select * from Details"
                let rows = try Row.fetchCursor(db, sql: query)
         
                while let row = try rows.next() {
                    info      = row["Information" ] ?? info
                    info      = row["Description" ] ?? info
                    name      = row["Title"       ] ?? info
                    abbr      = row["Abbreviation"] ?? ""
                    copyright = row["Copyright"   ] ?? ""
                    language  = row["Language"    ] ?? ""
                    strong    = row["Strong"      ] as Bool? ?? false
                    embedded  = row["Embedded"    ] as Bool? ?? false
                    default_  = row["Default"     ] as Bool? ?? false
                        
                    connected = true
                }
            }

            if format == .mybible {
                let query = "select * from info"
                let rows = try Row.fetchCursor(db, sql: query)
         
                while let row = try rows.next() {
                    guard let key   = row["name" ] as String? else { break }
                    guard let value = row["value"] as String? else { break }

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
   
    private func unbound2mybible(_ id: Int) -> Int {
        let range = 1..<myBibleArray.count
        return range.contains(id) ? myBibleArray[id] : id
    }

    private func mybible2unbound(_ id: Int) -> Int {
        myBibleArray.firstIndex(of: id) ?? id
    }

    func encodeID(_ id: Int) -> Int {
        format == .mybible ? unbound2mybible(id) : id
    }
    
    func decodeID(_ id: Int) -> Int {
        format == .mybible ? mybible2unbound(id) : id
    }
    
    static func isNewTestament(_ n: Int) -> Bool {
        (n >= 40) && (n < 77)
    }

    func delete() {
        try? database!.close()
        let url = dataUrl.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: url)
    }
	
}

