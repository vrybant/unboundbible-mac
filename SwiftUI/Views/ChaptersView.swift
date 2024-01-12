//
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct ChaptersView: View {
    var verse: Verse?

    init(name: String) {
        if let book = currBible!.bookByName(name) {
            verse = Verse(book: book, chapter: 1, number: 1, count: 1)
        }
    }
    
    var body: some View {
        let chaptersCount = currBible!.chaptersCount(verse!)
        let chapters = 1...chaptersCount
        
        List(chapters, id: \.self) { item in
            Text("Глава \(item)")
                .onTapGesture {
                    // verse!.chapter = item
                    currVerse = verse!
                    print(item)
                }
        }

    }
}

