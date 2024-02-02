//
//  Unbound Bible
//  Copyright © Vladimir Rybant. 
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
        let chaptersCount = currBible!.chaptersCount(book: book!)
        let chapters = 1...chaptersCount
        
        List(chapters, id: \.self) { item in
            Text("Глава \(item)")
                .onTapGesture {
                    BibleStore.shared.update(book: book!, chapter: item)
                    BibleStore.shared.router.removeAll()
                }
        }
        .navigationTitle(name!)

    }
}

#Preview {
    ChaptersView(name: "Genesis")
}

