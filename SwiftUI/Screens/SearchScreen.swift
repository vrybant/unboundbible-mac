//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange

import SwiftUI

struct SearchScreen: View {
    @State var selection: UUID? = nil
    @State var searchText = ""
    @State var content: [SearchItem] = []

    func update(text: String) {
        searchText = text
        content = searchText.isEmpty ? [] : tools.get_Search(string: searchText)
    }

    func onTap(_ item: SearchItem) {
        if let verse = currBible.stringToVerse(link: item.link) {
            if currBible.goodLink(verse) {
                currVerse = verse
                BibleModel.shared.route.removeAll()
                HomeModel.shared.route = .bible
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
                        Text(item.link)
                            .foregroundColor(.gray)
//                          .foregroundColor(Color(UIColor.darkGray))
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
            .searchable(text: $searchText, prompt: "Search text")
            .onSubmit(of: .search) {
                update(text: searchText)
            }
        }
    }
}

#Preview {
    SearchScreen()
}
