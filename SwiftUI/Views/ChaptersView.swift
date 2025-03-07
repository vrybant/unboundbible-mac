//
//  Unbound Bible
//  Copyright © Vladimir Rybant. 
//

import SwiftUI

struct ChaptersView: View {
    @State var selection: Int? = nil

    var name: String?
    var book: Int?
    
    init(name: String) {
        self.name = name
        
        if let book = currBible.bookByName(name) {
            self.book = book
        }
    }

    func onTap(_ chapter: Int) {
        selection = chapter
        BibleStore.shared.update(book: book!, chapter: chapter)
        BibleStore.shared.router.removeAll()
    }
    
    var body: some View {
        let chaptersCount = currBible.chaptersCount(book: book!)
        let chapters = 1...chaptersCount
        
        List(chapters, id: \.self, selection: $selection) { item in
            Text("Глава \(item)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    onTap(item)
                }
                .onLongPressGesture {
                    onTap(item)
                }

        }
        .padding(.top, -20)
        .navigationTitle(name!)

    }
}

#Preview {
    ChaptersView(name: "Genesis")
}

