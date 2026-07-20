//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

public struct BibleScreen: View {
    @State var appModel = AppModel.shared
    @State var bibleModel = BibleModel.shared
    @State var bookmarksModel = BookmarksModel.shared
    @State var content: [RowData] = []
    @State var showDialog = false
    @State var selection: UUID? = nil
    
    var title: String { currBible.verseToString(appModel.verse) ?? "" }

    func getContent() -> [RowData] {
        currBible.getChapter(book: appModel.verse.book, chapter: appModel.verse.chapter)
    }

    public var body: some View {
        NavigationStack(path: $bibleModel.router) {
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
                        appModel.update(number: item.number)
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
                            bookmarksModel.update(item)
                            
                            selection = nil
                        }
                        Button("Отмена", role: .cancel) {
                            selection = nil
                        }
                    } message: {
                        Text(title)
                    }
            }
            .onAppear { content = getContent() }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(title) {
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
