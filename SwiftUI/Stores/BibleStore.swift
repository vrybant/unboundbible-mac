//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

@Observable class BibleStore {
    static let shared = BibleStore()

    var book = 1
    var chapter = 1
    var content: [String]
    var router: [BibleRoute] = []

    private init() {
        content = tools.get_Chapter(book: 1, chapter: 1)
    }

    var title: String {
        let verse = Verse(book: book, chapter: chapter, count: 1)
        return currBible.verseToString(verse, cutted: true) ?? ""
    }
    
    func update(book: Int, chapter: Int) {
        self.book = book
        self.chapter = chapter
        refresh()
    }

    func refresh() {
        content = tools.get_Chapter(book: book, chapter: chapter)
    }
}
