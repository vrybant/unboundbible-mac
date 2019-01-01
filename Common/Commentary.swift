//
//  Commentary.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

class Commentary: Module {
    
    private var z = CommentaryAlias()
    
    override init?(atPath: String) {
        super.init(atPath: atPath)
        if format == .mybible { z = mybibleCommentaryAlias }
        if connected && !database!.tableExists(z.commentary) { return nil }
    }
    
    func getData(verse: Verse) -> String? {
        
        return nil
    }
    
    func getFootnote(verse: Verse, marker: String) -> String? {
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
    
    init() {
        load(path: dataPath)
        items.sort(by: {$0.name < $1.name} )
    }

    var isEmpty: Bool {
        return items.isEmpty
    }
    
    private func load(path: String) {
        let files = getDatabaseList(path).filter { $0.containsAny([".cmt.",".commentaries."]) }
        for file in files {
            if let item = Commentary(atPath: file) {
                items.append(item)
            }
        }
    }
    
    func getFootnote(module: String, verse: Verse, marker: String) -> String? {
        let name = module.lastPathComponentWithoutExtension
        
        for item in items {
            if !item.footnotes { continue }
            if !item.fileName.hasPrefix(name) { continue }
            return item.getFootnote(verse: verse, marker: marker)
        }
        return nil
    }
    
}
