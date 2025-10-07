//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

@Observable
class BibleModel {
    static let shared = BibleModel()

    var verse = currVerse
    var router: [BibleRoute] = []
    
    private init() {
//      verse.number = 0
    }

    var content: [IdentifiableString] {
        tools.get_Chapter(book: verse.book, chapter: verse.chapter).identifiable
    }
    
    var title: String {
        currBible.verseToString(verse, cutted: true) ?? ""
    }
    
    func update(book: Int, chapter: Int) {
        currVerse.book = book
        currVerse.chapter = chapter
        verse = currVerse
    }

    func refresh() {
        verse = currVerse
    }
}
