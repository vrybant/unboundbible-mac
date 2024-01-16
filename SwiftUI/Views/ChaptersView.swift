//
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct ChaptersView: View {
    @Environment(Router.self) private var router

    var verse: Verse?
    var name: String?
    
    init(name: String) {
        self.name = name
        
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
                    router.bibleRoutes.removeAll()
                    router.bibleRoutes.removeLast()
                }
        }
        .navigationTitle(name!)

    }
}

