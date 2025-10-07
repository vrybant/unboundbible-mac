//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange

import SwiftUI

struct SearchScreen: View {
    @State var model = SearchModel()
    @State var selection: UUID? = nil

    func onTap(_ item: SearchItem) {
        if let verse = currBible.stringToVerse(link: item.link) {
            if currBible.goodLink(verse) {
//              currVerse = verse
                BibleModel.shared.update(book: verse.book, chapter: verse.chapter)
                BibleModel.shared.router.removeAll()
                HomeModel.shared.selection = .bible
            }
        }

    }
    
    var body: some View {
        VStack {
            NavigationStack {
                let content = model.content
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
            .searchable(text: $model.searchText, prompt: "Search text")
            .onSubmit(of: .search) {
                model.update(text: model.searchText)
            }
        }
    }
}

#Preview {
    SearchScreen()
}
