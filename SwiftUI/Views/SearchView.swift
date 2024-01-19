//
//  SwiftUI
//  Copyright © 2024 Vladimir Rybant. All rights reserved.
//

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-search-bar-to-filter-your-data
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange

import SwiftUI

func searchResult(text: String) -> [String] {
    if text.count < 2 { return [] }
    let data = tools.get_Search(string: text).strings
    return data
}

struct SearchView: View {
    @State private var results = [String]()
    @State private var searchText = ""

    var body: some View {
        VStack {
            NavigationStack {
                List (results, id: \.self) { item in
                    let attrString = parse(item)
                    let content = AttributedString(attrString)
                    Text(content)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Search")
            }
            .searchable(text: $searchText, prompt: "Search text")
            .onSubmit(of: .search) {
                print("SearchText is now \(searchText)")
                results = searchResult(text: searchText)
            }
        }
    }
}

#Preview {
    SearchView()
}
