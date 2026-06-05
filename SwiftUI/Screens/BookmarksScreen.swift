//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

struct BookmarksScreen: View {
    @State var bookmarksModel = BookmarksModel.shared
    @State var selection: UUID? = nil
        
    func onTap(_ item: RowData) {
        if currBible.goodLink(item) {
            BibleModel.shared.update(book: item.book, chapter: item.chapter)
            BibleModel.shared.router.removeAll()
            HomeModel.shared.selection = .bible
        }
    }
 
    func onTrashTap() {
        bookmarksModel.content.removeAll()
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
            .listStyle(.plain)
            .padding(.top, -20)
            .navigationTitle("Bookmarks")
            .safeNavigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onTrashTap) {
                        Image(systemName: "trash")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { print("Change Button Tapped") }) {
                        Text("Change")
                    }
                }
            }

        }
    }
    
}

#Preview {
    BookmarksScreen()
}

