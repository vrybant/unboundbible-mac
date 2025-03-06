//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-search-bar-to-filter-your-data
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange

import SwiftUI

struct SearchScreen: View {
    @State var store = SearchStore.shared

    var body: some View {
        VStack {
            NavigationStack {
                List (store.content, id: \.self) { item in
                    let attrString = parse(item)
                    let content = AttributedString(attrString)
                    Text(content)
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
