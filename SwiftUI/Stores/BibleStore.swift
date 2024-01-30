//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation
import Combine

class BibleStore: ObservableObject {
    static let shared = BibleStore()

    @Published var verse = currVerse
    @Published var content = tools.get_Chapter()
    @Published var router: [BibleRoute] = []

    private init() {}

    var title: String {
        currBible!.verseToString(verse, cutted: true) ?? ""
    }
    
    func update(verse: Verse) {
        self.verse = verse
        currVerse = verse
        update()
    }

    func update() {
        content = tools.get_Chapter()
    }
}
