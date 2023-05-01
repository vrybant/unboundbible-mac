//
//  Reference.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation
import GRDB

private protocol ReferenceAlias {
    var xreferences : String { get }
    var book        : String { get }
    var chapter     : String { get }
    var verse       : String { get }
    var xbook       : String { get }
    var xchapter    : String { get }
    var xfromverse  : String { get }
    var xtoverse    : String { get }
    var votes       : String { get }
}

private struct UnboundAlias : ReferenceAlias {
    var xreferences = "xreferences"
    var book        = "book"
    var chapter     = "chapter"
    var verse       = "verse"
    var xbook       = "xbook"
    var xchapter    = "xchapter"
    var xfromverse  = "xfromverse"
    var xtoverse    = "xtoverse"
    var votes       = "votes"
}

private struct MybibleAlias : ReferenceAlias {
    var xreferences = "cross_references"
    var book        = "book"
    var chapter     = "chapter"
    var verse       = "verse"
//  var toverse     = "verse_end"
    var xbook       = "book_to"
    var xchapter    = "chapter_to"
    var xfromverse  = "verse_to_start"
    var xtoverse    = "verse_to_end"
    var votes       = "votes"
}

class Reference: Module {
    private var z : ReferenceAlias = UnboundAlias()
    
    override init?(atPath: String) {
        super.init(atPath: atPath)
        if format == .mybible { z = MybibleAlias() }
//        if connected && !tableExists(z.xreferences) { return nil }
    }
    
    func getData(_ verse : Verse) -> [Verse]? {
        let id = encodeID(verse.book)
        let v_from = verse.number
        let v_to   = verse.number + verse.count - 1
        
        let query = "SELECT * FROM \(z.xreferences) WHERE \(z.book) = \(id) " +
                    "AND \(z.chapter) = \(verse.chapter) " +
                    "AND (\(z.verse) BETWEEN \(v_from) AND \(v_to)) "
        
        var result = [Verse]()
        
        try? database!.read { db in
            let rows = try Row.fetchCursor(db, sql: query)
            while let row = try rows.next() {
                let book    = row[z.xbook     ] as Int? ?? 0
                let chapter = row[z.xchapter  ] as Int? ?? 0
                let number  = row[z.xfromverse] as Int? ?? 0
                let toverse = row[z.xtoverse  ] as Int? ?? 0
                let votes   = row[z.votes     ] as Int? ?? 0

                if votes <= 1 { continue }
                let count = toverse == 0 ? 1 : toverse - number + 1

                let item = Verse(book: decodeID(book), chapter: chapter, number: number, count: count)
                result.append(item)
            }
        }
        return result.isEmpty ? nil : result
    }

}

extension Array where Element == Reference {
    
    init(_: Bool) {
        self.init()
        load()
    }
    
    private mutating func load() {
        let files = databaseList.filter { $0.containsAny([".xrefs."]) } // .crossreferences.
        for file in files {
            if let item = Reference(atPath: file) {
                self.append(item)
            }
        }
    }

    private func referenceByLanguage(_ language: String) -> Reference? {
        for reference in self {
            if reference.language == language { return reference }
        }
        return nil
    }
    
    func getData(_ verse: Verse, language: String) -> (data: [Verse], info: String)? {
        if let reference = referenceByLanguage(language) ?? referenceByLanguage("en") {
            if let data = reference.getData(verse) {
                return (data, reference.info)
            }
        }
        return nil
    }

    mutating func deleteItem(_ item: Reference) {
        item.delete()
        self.removeAll(where: { $0 === item })
    }
    
}
