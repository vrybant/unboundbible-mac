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

    var body: some View {
        let chaptersCount = currBible.chaptersCount(book: book!)
        let chapters = 1...chaptersCount
        
        List(chapters, id: \.self, selection: $selection) { item in
            Text("Глава \(item)")
                .id(item)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    handleAction(for: item)
                }
                .onLongPressGesture() {
                    handleAction(for: item)
                }
        }
        .padding(.top, -20)
        .listStyle(.plain)
        .navigationTitle(name!)

    }
    
    private func handleAction(for item: Int) {
        selection = item
        currVerse = Verse(book: book!, chapter: item)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            BibleModel.shared.route.removeAll()
        }
    }

}

#Preview {
    ChaptersView(name: "Genesis")
}

