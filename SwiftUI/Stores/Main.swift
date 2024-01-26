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
    var content = tools.get_Chapter()

    func update(verse: Verse) {
        self.verse = verse
        currVerse = verse
        updateContent()
    }

    func updateContent() {
        content = tools.get_Chapter()
    }
    
    static let shared = MainStore()
    private init() {}
}
