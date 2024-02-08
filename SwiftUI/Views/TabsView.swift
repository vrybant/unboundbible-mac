//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

struct TabsView: View {
    @ObservedObject var store = TabsStore.shared
    
    var body: some View {
        TabView(selection: $store.selection) {
            BibleView()
                .tag(TabsRoute.bible)
                .tabItem {
                    Label("Bible", systemImage: "book")
                }
            SearchView()
                .tag(TabsRoute.search)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            ShelfView()
                .tag(TabsRoute.shelf)
                .tabItem {
                    Label("Modules", systemImage: "books.vertical")
                }
            BookmarksView()
                .tag(TabsRoute.bookmarks)
                .tabItem {
                    Label("Bookmarks", systemImage: "bookmark")
                }
            OptionsView()
                .tag(TabsRoute.options)
                .tabItem {
                    Label("Options", systemImage: "gear")
                }
        }
    }
}

#Preview {
    TabsView()
}
