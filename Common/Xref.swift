//
//  Xref.swift
//  Unbound Bible
//
//  Created by Vladimir Rybant on 25.05.2020.
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import Foundation

class TXref: Module {
    
    private var z = XrefAlias()
    
    override init?(atPath: String) {
        super.init(atPath: atPath)!
// //////////        if format == .mybible { z = mybibleXrefAlias }
        z = mybibleXrefAlias
        if connected && !database!.tableExists(z.xrefs) { return nil }
    }
    
    func getData(_ verse : Verse) -> [Verse]? {
        let id = encodeID(verse.book)
        let v_from = verse.number
        let v_to   = verse.number + verse.count - 1
        
        let query = "select * from \(z.xrefs) " +
                    "where \(z.book) = \(id) " +
                    "and \(z.chapter) = \(verse.chapter) " +
                    "and (( \(v_from) between \(z.fromverse) and \(z.toverse) ) " +
                    "or ( \(z.fromverse) between \(v_from) and \(v_to) )) "
        
        var result = [Verse]()
        if let results = database!.executeQuery(query) {
            while results.next() {
                guard let book = results.string(forColumn: z.xbook) else { continue }
                guard let chapter = results.string(forColumn: z.xchapter) else { continue }
                guard let number = results.string(forColumn: z.xfromverse) else { continue }
//              guard let line = results.string(forColumn: z.xtoverse) else { continue }
                
                let item = Verse(book: decodeID(book.int), chapter: chapter.int, number: number.int, count: 1)
                result.append(item)
            }
        }
        return result.isEmpty ? nil : result
    }

}

var xrefs = Xrefs()

class Xrefs {
    
    var items = [TXref]()
    
    init() {
        load()
    }
    
    private func load() {
        let files = databaseList().filter { $0.containsAny([".xrefs.",".crossreferences."]) }
        for file in files {
// //             if !file.hasSuffix(".unbound") { continue }
            if let item = TXref(atPath: file) {
                items.append(item)
            }
        }
    }
        
}
