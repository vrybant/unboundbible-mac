//
//  Reference.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Foundation

private protocol ReferenceAliases {
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

class Reference: Module {
    
    private struct UnboundAliases : ReferenceAliases {
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

    private struct MybibleAliases : ReferenceAliases {
        var xreferences = "cross_references"
        var book        = "book"
        var chapter     = "chapter"
        var verse       = "verse"
//      var toverse     = "verse_end"
        var xbook       = "book_to"
        var xchapter    = "chapter_to"
        var xfromverse  = "verse_to_start"
        var xtoverse    = "verse_to_end"
        var votes       = "votes"
    }

    private var z : ReferenceAliases = UnboundAliases()
    
    override init?(atPath: String) {
        super.init(atPath: atPath)!
        if format == .mybible { z = MybibleAliases() }
        if connected && !database.tableExists(z.xreferences) { return nil }
    }
    
    func getData(_ verse : Verse) -> [Verse]? {
        let id = encodeID(verse.book)
        let v_from = verse.number
        let v_to   = verse.number + verse.count - 1
        
        let query = "select * from \(z.xreferences) " +
                    "where \(z.book) = \(id) " +
                    "and \(z.chapter) = \(verse.chapter) " +
                    "and (\(z.verse) between \(v_from) and \(v_to)) "
        
        var result = [Verse]()
        if let results = database.executeQuery(query) {
            while results.next() {
                let book = results.int(forColumn: z.xbook).int
                let chapter = results.int(forColumn: z.xchapter).int
                let number = results.int(forColumn: z.xfromverse).int
                let toverse = results.int(forColumn: z.xtoverse).int
                let votes = results.int(forColumn: z.votes).int

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
