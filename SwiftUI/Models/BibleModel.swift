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

    private init() {}

    var content: [RowData] {
        currBible.getChapter(book: verse.book, chapter: verse.chapter)
    }

    var title: String {
        currBible.verseToString(verse) ?? ""
    }
    
    func update(number: Int = 1) {
        currVerse.number = number
        verse = currVerse
        
        print("updated")
        print(verse)
    }

    func update(book: Int, chapter: Int, number: Int = 1) {
        currVerse.book = book
        currVerse.chapter = chapter
        currVerse.number = number
        verse = currVerse
        
        print("updated")
        print(verse)
    }
    
    func refresh() {
        verse = currVerse
    }
}
