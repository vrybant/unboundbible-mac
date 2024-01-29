//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation
import Combine

class MainStore: ObservableObject {
    static let shared = MainStore()

    @Published var verse = currVerse
    @Published var content = tools.get_Chapter()

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
