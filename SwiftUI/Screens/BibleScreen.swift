//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

public struct BibleScreen: View {
    @State var bibleModel = BibleModel.shared
    @State var bookmarksModel = BookmarksModel.shared
    @State var content: [RowData] = []
    @State var showDialog = false
    @State var selection: UUID? = nil
    
    var title: String { currBible.verseToString(currVerse) ?? "" }

    func update() {
        content = currBible.getChapter(book: currVerse.book, chapter: currVerse.chapter)
    }

    public var body: some View {
        NavigationStack(path: $bibleModel.route) {
            List(content, id: \.id, selection: $selection) { item in
                let string = "<l>\(item.number).</l> \(item.text)"
                let attrString = parse(string)
                let edgeInsets : EdgeInsets = .init(top: 1, leading: 15, bottom: 1, trailing: 15)
                Text(attrString)
                    .listRowInsets(edgeInsets)
                    .listRowSeparator(.hidden)
                    .font(.body)
                    .dynamicTypeSize(.xLarge)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                  .background(.red)
                    .onTapGesture {
                        selection = item.id
                        currVerse.number = item.number
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
//                          let bookmark = IdentifiableString(string: bibleModel.title)
                            bookmarksModel.content.append(item)
                            selection = nil
                        }
                        Button("Отмена", role: .cancel) {
                            selection = nil
                        }
                    } message: {
                        Text(title)
                    }
            }
            .onAppear { update() }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(title) {
                        bibleModel.route.append(.books)
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
