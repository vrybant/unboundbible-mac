//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

struct BookmarksScreen: View {
    @State var bookmarksModel = BookmarksModel.shared
    @State var selection: UUID? = nil
        
    func onTap(_ item: RowData) {
        let verse = item.verse
        if currBible.goodLink(verse) {
            BibleModel.shared.update(book: verse.book, chapter: verse.chapter)
            BibleModel.shared.router.removeAll()
            HomeModel.shared.selection = .bible
        }
    }
    
    var body: some View {
        NavigationStack {
            List(bookmarksModel.content,  id: \.id, selection: $selection) { item in
                let attrString = parse(item.text)
                let link = currBible.verseToString(item.verse) ?? "---"
                VStack(alignment: .leading) {
                    Text(attrString)
                    Text(link)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    selection = item.id
                    onTap(item)
                }
            }
            .padding(.top, -20)
            .navigationTitle("Bookmarks")
            .safeNavigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { print("Trash Button Tapped") }) {
                        Image(systemName: "trash")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { print("Ellipsis Button Tapped") }) {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
    }
}

#Preview {
    BookmarksScreen()
}
