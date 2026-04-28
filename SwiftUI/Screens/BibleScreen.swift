//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

public struct BibleScreen: View {
    @State var bibleModel = BibleModel.shared
    @State var bookmarksModel = BookmarksModel.shared
    @State var showDialog = false
    @State var selection: UUID? = nil

    public var body: some View {
        NavigationStack(path: $bibleModel.router) {
            List(bibleModel.content, selection: $selection) { item in
                let attrString = parse(item.string)
                let edgeInsets : EdgeInsets = .init(top: 7, leading: 15, bottom: 7, trailing: 15)
                Text(attrString)
                    .listRowInsets(edgeInsets)
                    .listRowSeparator(.hidden)
                    .font(.body)
                    .dynamicTypeSize(.xLarge)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                  .background(.red)
                    .onTapGesture {
                        selection = item.id
                        bibleModel.update(book: bibleModel.verse.book, chapter: bibleModel.verse.chapter, number: item.num)
                        showDialog = true
                    }
                    .confirmationDialog("Change background", isPresented: $showDialog) {
                        Button("Копировать") {
                            let verses = tools.get_Verses(options: copyOptions)
                            copyToPasteboard(parse(verses))
                            selection = nil
                        }
                        Button("Сравнить") {
                            print("compare...")
                            selection = nil
                        }
                        Button("Закладка") {
                            let bookmark = IdentifiableString(string: bibleModel.title)
                            bookmarksModel.update(bookmark)
                            
                            selection = nil
                        }
                        Button("Отмена", role: .cancel) {
                            selection = nil
                        }
                    } message: {
                        Text(bibleModel.title)
                    }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(bibleModel.title) {
                        bibleModel.router.append(.books)
                    }
                    .bold()
                }
            }
            .navigationDestination(for: BibleRoute.self) { $0 }
            .safeNavigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    BibleScreen()
}
