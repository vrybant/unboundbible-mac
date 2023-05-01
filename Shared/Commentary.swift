//
//  Commentary.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation
import GRDB

private protocol CommentaryAlias {
    var commentary : String { get }
    var id         : String { get }
    var book       : String { get }
    var chapter    : String { get }
    var fromverse  : String { get }
    var toverse    : String { get }
    var data       : String { get }
}

private struct UnboundAlias : CommentaryAlias {
    var commentary = "commentary"
    var id         = "id"
    var book       = "book"
    var chapter    = "chapter"
    var fromverse  = "fromverse"
    var toverse    = "toverse"
    var data       = "data"
}

private struct MybibleAlias : CommentaryAlias {
    var commentary = "commentaries"
    var id         = "id"
    var book       = "book_number"
    var chapter    = "chapter_number_from"
    var fromverse  = "verse_number_from"
//  var chapter    = "chapter_number_to"
    var toverse    = "verse_number_to"
//  var marker     = "marker"
    var data       = "text"
}

class Commentary: Module {    
    private var z : CommentaryAlias = UnboundAlias()
    
    override init?(atPath: String) {
        super.init(atPath: atPath)
        if format == .mybible { z = MybibleAlias() }
        if connected && !tableExists(z.commentary) { return nil }
    }

    func getData(_ verse : Verse) -> [String]? {
        var result = [String]()
        let id = encodeID(verse.book)
        let v_from = verse.number
        let v_to   = verse.number + verse.count - 1
        
        let query = "SELECT * FROM \(z.commentary) WHERE \(z.book) = \(id) " +
                    "AND \(z.chapter) = \(verse.chapter) " +
                    "AND (( \(v_from) BETWEEN \(z.fromverse) AND \(z.toverse) ) " +
                    "OR ( \(z.fromverse) BETWEEN \(v_from) AND \(v_to) )) "
        
        try? database!.read { db in
            let rows = try Row.fetchCursor(db, sql: query)
            while let row = try rows.next() {
                let line = row[z.data] as String? ?? ""
                if !line.isEmpty { result.append(line) }
            }
        }
        return result.isEmpty ? nil : result
    }

    func getFootnote(_ verse: Verse, marker: String) -> String? {
        var result: String?
        let id = encodeID(verse.book)

        let query = "SELECT * FROM \(z.commentary) WHERE \(z.book) = \(id) " +
                    "AND \(z.chapter) = \(verse.chapter) AND marker = '\(marker)' "

        try? database!.read { db in
            if let row = try Row.fetchOne(db, sql: query) {
                result = row[z.data] as String?
            }
        }
        return result
    }
    
}

fileprivate func mysort(_ name: String,_ language: String) -> String {
    language == languageCode ? " " + name : name
}

extension Array where Element == Commentary {
    
    init(_: Bool) {
        self.init()
        load()
        self.sort(by: { mysort($0.name, $0.language) < mysort($1.name, $1.language) } )
    }

    private mutating func load() {
        let files = databaseList.filter { $0.containsAny([".cmt.",".commentaries."]) }
        for file in files {
            if let item = Commentary(atPath: file) {
                self.append(item)
            }
        }
    }
    
    var footnotesOnly: Bool {
        for item in self {
            if !item.footnotes { return false }
        }
        return true
    }
    
    func getFootnote(module: String, verse: Verse, marker: String) -> String? {
        let name = module.lastPathComponentWithoutExtension
        for item in self {
            if !item.footnotes { continue }
            if !item.fileName.hasPrefix(name) { continue }
            return item.getFootnote(verse, marker: marker)
        }
        return nil
    }
    
    mutating func deleteItem(_ item: Commentary) {
        item.delete()
        self.removeAll(where: { $0 === item })
    }
    
}
