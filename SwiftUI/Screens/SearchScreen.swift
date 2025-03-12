//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange

import SwiftUI

struct SearchScreen: View {
    @State var store = SearchStore.shared
    @State var selection: UUID? = nil
    let content = SearchStore.shared.content

    func onTap(_ item: SearchItem) {
        if let verse = currBible.stringToVerse(link: item.link) {
            if currBible.goodLink(verse) {
//              currVerse = verse
                BibleStore.shared.update(book: verse.book, chapter: verse.chapter)
                BibleStore.shared.router.removeAll()
                HomeStore.shared.selection = .bible
            }
        }

    }
    
    var body: some View {
        VStack {
            NavigationStack {
                List(content, selection: $selection) { item in
                    let attrString = parse(item.text)
                    VStack(alignment: .leading) {
                        Text(attrString)
                        Text(parse(item.link))
                    }
//                  .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        selection = item.id
                        onTap(item)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Search")
                .safeNavigationBarTitleDisplayMode(.inline)
            }
            .searchable(text: $store.searchText, prompt: "Search text")
            .onSubmit(of: .search) {
                store.update(text: store.searchText)
            }
        }
    }
}

#Preview {
    SearchScreen()
}
