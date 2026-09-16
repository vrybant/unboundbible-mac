//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

public struct BibleScreen: View {
    @State var bibleModel = BibleModel.shared
    @State var bookmarksModel = BookmarksModel.shared
    @State var content: [RowData] = []
    @State var showAlert = false
    @State var selection: RowData? = nil
    
    var title: String {
        currBible.verseToString(currVerse, cutted: true) ?? ""
    }

    var selectedVerse: String {
        currBible.verseToString(currVerse, cutted: false) ?? ""
    }

    var currID: Int? {
        content.first { $0.number == currVerse.number }?.number
    }
    
    func update() {
        content = currBible.getChapter(book: currVerse.book, chapter: currVerse.chapter)
    }

    public var body: some View {
        NavigationStack(path: $bibleModel.route) {
            ScrollViewReader { proxy in
                List(content, id: \.self, selection: $selection) { item in
                    let string = "<l>\(item.number).</l> \(item.text)"
                    let attrString = parse(string)
                    let edgeInsets : EdgeInsets = .init(top: 1, leading: 15, bottom: 1, trailing: 15)
                    Text(attrString)
                        .id(item)
                        .listRowInsets(edgeInsets)
                        .listRowSeparator(.hidden)
                        .font(.body)
                        .dynamicTypeSize(.xLarge)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
//                      .background(.red)
                        .onTapGesture {
                            handleAction(for: item)
                        }
                        .alert(selectedVerse, isPresented: $showAlert, actions: {
                            Button("Копировать") {
                                let verses = tools.get_Verses(options: copyOptions)
                                copyToPasteboard(parse(verses))
                                selection = nil
                            }
                            Button("Закладка") {
                                if let bookmark = selection {
                                    bookmarksModel.content.append(bookmark)
                                }
                                selection = nil
                            }
                            Button("Отмена", role: .cancel) {
                                selection = nil
                            }
                        })
                    
                }
                .onAppear {
                    update()

                    if let cid = currID {
                        Task { @MainActor in
                            await Task.yield()
                            withAnimation {
                                proxy.scrollTo(cid, anchor: .center)
                            }
                        }
                    }
                    
                }
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
    
    private func handleAction(for item: RowData) {
        selection = item
        currVerse.number = item.number
        Task {
            try? await Task.sleep(for: .seconds(0.05))
            showAlert = true
        }
    }

}

#Preview {
    BibleScreen()
}
