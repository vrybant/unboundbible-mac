//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange

import SwiftUI

struct SearchScreen: View {
    @State var content: [RowData] = []
    @State var selection: RowData? = nil
    @State var searchText = ""

    var body: some View {
        VStack {
            NavigationStack {
                List(content, id: \.self, selection: $selection) { item in
                    let attrText = parse(item.text)
                    let link = currBible.verseToString(item.verse) ?? "Unknown"
                    VStack(alignment: .leading) {
                        Text(attrText)
                        Text(link)
                            .foregroundColor(.gray)
//                          .foregroundColor(Color(UIColor.darkGray))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selection = item
                        handleAction(for: item)
                    }
                    .onLongPressGesture {
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
    
    func update(text: String) {
        searchText = text
        content = searchText.isEmpty ? [] : tools.get_Search(string: searchText)
    }

    private func handleAction(for item: RowData) {
        if !currBible.goodLink(item) { return }
        selection = item
        Task {
            try? await Task.sleep(for: .seconds(0.05))
            currVerse = Verse(book: item.book, chapter: item.chapter, number: item.number)
            BibleModel.shared.route.removeAll()
            HomeModel.shared.route = .bible
        }
        Task {
            try? await Task.sleep(for: .seconds(0.5))
            selection = nil
        }
    }

}

#Preview {
    SearchScreen()
}
