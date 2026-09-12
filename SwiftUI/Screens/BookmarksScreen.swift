//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

struct BookmarksScreen: View {
    @Bindable var bookmarksModel = BookmarksModel.shared
    @State var selection: RowData? = nil
    @State private var showAlert = false
        
    var body: some View {
        NavigationStack {
            List($bookmarksModel.content, id: \.self, editActions: .all, selection: $selection) { item in
                let attrString = parse(item.wrappedValue.text)
                let link = currBible.verseToString(item.wrappedValue.verse) ?? "---"
                VStack(alignment: .leading) {
                    Text(attrString)
                    Text(link)
                        .foregroundColor(.gray)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    handleAction(for: item.wrappedValue)
                }
            }
            .listStyle(.plain)
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
        .alert("Удалить все закладки?", isPresented: $showAlert) {
            Button("Удалить", role: .destructive) {
                bookmarksModel.content.removeAll()
            }
            Button("Отмена", role: .cancel) {
            }
        } message: {
            Text("Это действие нельзя отменить.")
        }
    }

    private func handleAction(for item: RowData) {
        if !currBible.goodLink(item) { return }
        selection = item
        Task {
            try? await Task.sleep(for: .seconds(0.05))
            currVerse = Verse(book: item.book, chapter: item.chapter, number: item.number)
            BibleModel.shared.route.removeAll()
            HomeModel.shared.route = .bible
        }
        Task {
            try? await Task.sleep(for: .seconds(0.5))
            selection = nil
        }
    }

    private func onTrashTap() {
        showAlert = true
    }
  
}

#Preview {
    BookmarksScreen()
}

