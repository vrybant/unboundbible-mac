//
//  Unbound Bible
//
//  Copyright © Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct ChaptersView: View {

    var name: String?
    var book: Int?
    
    init(name: String) {
        self.name = name
        
        if let book = currBible!.bookByName(name) {
            self.book = book
        }
    }
    
    var body: some View {
        var verse = Verse(book: book!, chapter: 1, number: 1, count: 1)
        let chaptersCount = currBible!.chaptersCount(verse)
        let chapters = 1...chaptersCount
        
        List(chapters, id: \.self) { item in
            Text("Глава \(item)")
                .onTapGesture {
                    verse.chapter = item
                    MainStore.shared.update(verse: verse)
                    Router.shared.bibleRoutes.removeAll()
                }
        }
        .navigationTitle(name!)

    }
}

#Preview {
    ChaptersView(name: "Genesis")
}

