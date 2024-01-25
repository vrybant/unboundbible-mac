//
//  SwiftUI
//
//  Copyright ©  Vladimir Rybant. All rights reserved.
//

import Foundation
import Observation

@Observable
class MainStore {
    var verse = currVerse
    
    static let shared = MainStore()
    private init() {}

    func update(newVerse: Verse) {
        verse = newVerse
        currVerse = verse
    }
    
    var infoString: String {
        tools.get_Info(book: verse.book, chapter: verse.chapter)
    }
}
