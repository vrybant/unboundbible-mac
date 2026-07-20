//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

@Observable
class AppModel {
    static let shared = AppModel()
    
    var verse : Verse { currVerse }
    
    init() {}
    
    func update(number: Int = 1) {
//        currVerse.number = number
//        verse = currVerse
//        
//        print("updated")
//        print(verse)
    }

    func update(book: Int, chapter: Int, number: Int = 1) {
//        currVerse.book = book
//        currVerse.chapter = chapter
//        currVerse.number = number
//        verse = currVerse
//        
//        print("updated")
//        print(verse)
    }
    
    func refresh() {
//        verse = currVerse
    }

    
}
