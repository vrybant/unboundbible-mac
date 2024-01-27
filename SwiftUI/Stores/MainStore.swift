//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation
import Observation

@Observable
class MainStore {
    static let shared = MainStore()

    var verse = currVerse
    var content = tools.get_Chapter()

    private init() {}

    func update(verse: Verse) {
        self.verse = verse
        currVerse = verse
        update()
    }

    func update() {
        content = tools.get_Chapter()
    }
}
