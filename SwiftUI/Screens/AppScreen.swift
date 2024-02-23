//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

struct AppScreen: View {
    @ObservedObject var store = TabsStore.shared
    
    var body: some View {
        TabView(selection: $store.selection) {
            BibleScreen()
                .tag(TabsRoute.bible)
                .tabItem {
                    Label("Bible", systemImage: "book")
                }
            SearchScreen()
                .tag(TabsRoute.search)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            ShelfScreen()
                .tag(TabsRoute.shelf)
                .tabItem {
                    Label("Modules", systemImage: "books.vertical")
                }
            BookmarksScreen()
                .tag(TabsRoute.bookmarks)
                .tabItem {
                    Label("Bookmarks", systemImage: "bookmark")
                }
            OptionsScreen()
                .tag(TabsRoute.options)
                .tabItem {
                    Label("Options", systemImage: "gear")
                }
        }
    }
}

#Preview {
    AppScreen()
}
