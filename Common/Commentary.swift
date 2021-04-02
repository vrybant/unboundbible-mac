//
//  Commentary.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Foundation

class Commentary: Module {
    
    private struct Alias {
        var commentary = "commentary"
        var id = "id"
        var book = "book"
        var chapter = "chapter"
        var fromverse = "fromverse"
        var toverse = "toverse"
        var data = "data"
    }

    private let mybibleAlias = Alias(
        commentary: "commentaries",
        id: "id",
        book: "book_number",
        chapter: "chapter_number_from",
        fromverse: "verse_number_from",
    //  chapter: "chapter_number_to"
        toverse: "verse_number_to",
    //  marker : "marker"
        data: "text"
    )

    private var z = Alias()
    
    override init?(atPath: String) {
        super.init(atPath: atPath)
        if format == .mybible { z = mybibleAlias }
        if connected && !database!.tableExists(z.commentary) { return nil }
    }

    func getData(_ verse : Verse) -> [String]? {
        let id = encodeID(verse.book)
        let v_from = verse.number
        let v_to   = verse.number + verse.count - 1
        
        let query = "select * from \(z.commentary) " +
                    "where \(z.book) = \(id) " +
                    "and \(z.chapter) = \(verse.chapter) " +
                    "and (( \(v_from) between \(z.fromverse) and \(z.toverse) ) " +
                    "or ( \(z.fromverse) between \(v_from) and \(v_to) )) "
        
        var result = [String]()
        if let results = database!.executeQuery(query) {
            while results.next() {
                if let line = results.string(forColumn: z.data) {
                    if !line.isEmpty { result.append(line) }
                }
            }
        }
        return result.isEmpty ? nil : result
    }

    func getFootnote(_ verse: Verse, marker: String) -> String? {
        let id = encodeID(verse.book)
        let query = "select * from \(z.commentary) where \(z.book) = \(id) and \(z.chapter) = \(verse.chapter) and marker = \"\(marker)\" "
        if let results = database!.executeQuery(query) {
            if results.next() {
                return results.string(forColumn: z.data)
            }
        }
        return nil
    }
    
}

var commentaries = Commentaries()

class Commentaries {
    
    var items = [Commentary]()
    
    private func sort(_ s: String,_ language: String) -> String {
        return language == languageCode ? " " + s : s
    }
    
    init() {
        load()
        items.sort(by: { sort($0.name, $0.language) < sort($1.name, $1.language) } )
    }
    
    private func load() {
        let files = databaseList().filter { $0.containsAny([".cmt.",".commentaries."]) }
        for file in files {
            if let item = Commentary(atPath: file) {
                items.append(item)
            }
        }
    }
    
    var footnotesOnly: Bool {
        for item in items {
            if !item.footnotes { return false }
        }
        return true
    }
    
    func getFootnote(module: String, verse: Verse, marker: String) -> String? {
        let name = module.lastPathComponentWithoutExtension
        
        for item in items {
            if !item.footnotes { continue }
            if !item.fileName.hasPrefix(name) { continue }
            return item.getFootnote(verse, marker: marker)
        }
        return nil
    }
    
}
