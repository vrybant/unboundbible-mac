//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

struct BookmarksScreen: View {
    @Bindable var bookmarksModel = BookmarksModel.shared
    @State var selection: UUID? = nil
        
    func onTap(_ item: RowData) {
        if currBible.goodLink(item) {
            currVerse = Verse(book: item.book, chapter: item.chapter)
            BibleModel.shared.route.removeAll()
            HomeModel.shared.route = .bible
        }
    }
 
    func onTrashTap() {
        bookmarksModel.content.removeAll()
    }
  
    var body: some View {
        NavigationStack {
            List($bookmarksModel.content, id: \.id, editActions: .all, selection: $selection) { $item in
                let attrString = parse($item.wrappedValue.text)
                let link = currBible.verseToString($item.wrappedValue.verse) ?? "---"
                VStack(alignment: .leading) {
                    Text(attrString)
                    Text(link)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    selection = $item.wrappedValue.id
                    onTap($item.wrappedValue)
                }
            }
            .listStyle(.plain)
            .padding(.top, -20)
            .navigationTitle("Bookmarks")
            .safeNavigationBarTitleDisplayMode(.inline)
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onTrashTap) {
                        Image(systemName: "trash")
                    }
                }
                #endif
            }

        }
    }
    
}

#Preview {
    BookmarksScreen()
}
