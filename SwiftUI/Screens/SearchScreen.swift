//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange

import SwiftUI

struct SearchScreen: View {
    @State var store = SearchStore.shared
    @State var selection: String? = nil

    func onTap(_ item: String) {
        selection = item
//      BibleStore.shared.update(book: book!, chapter: chapter)
//      BibleStore.shared.router.removeAll()
        HomeStore.shared.selection = .bible
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                List(store.content, id: \.self, selection: $selection) { item in
                    let attrString = parse(item)
                    let content = AttributedString(attrString)
                    Text(content)
                        .onTapGesture {
                            onTap(item)
                        }
                }
                .navigationTitle("Search")
                .safeNavigationBarTitleDisplayMode(.inline)
            }
            .searchable(text: $store.searchText, prompt: "Search text")
            .onSubmit(of: .search) {
                print("SearchText is now \(store.searchText)")
                store.update(text: store.searchText)
            }
        }
    }
}

#Preview {
    SearchScreen()
}
