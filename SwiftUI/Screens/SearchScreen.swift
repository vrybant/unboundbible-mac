//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange

import SwiftUI

struct SearchScreen: View {
    @State var store = SearchStore.shared
    @State var selection: UUID? = nil

    func onTap(_ item: SearchItem) {
//        selection = item
//      BibleStore.shared.update(book: book!, chapter: chapter)
//      BibleStore.shared.router.removeAll()
//        HomeStore.shared.selection = .bible
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                List(store.content, selection: $selection) { item in
                    let attrString = parse(item.string)
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
