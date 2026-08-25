//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

struct HomeScreen: View {
    @State var model = HomeModel.shared
    
    var body: some View {
        TabView(selection: $model.route) {
            BibleScreen()
                .tag(HomeRoute.bible)
                .tabItem {
                    Image(systemName: "book")
                    Text("Bible")
                }
            SearchScreen()
                .tag(HomeRoute.search)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            BookmarksScreen()
                .tag(HomeRoute.bookmarks)
                .tabItem {
                    Label("Bookmarks", systemImage: "bookmark")
                }
            ShelfScreen()
                .tag(HomeRoute.shelf)
                .tabItem {
                    Label("Modules", systemImage: "books.vertical")
                }
            #if os(iOS)
            AboutScreen()
                .tag(HomeRoute.about)
                .tabItem {
                    Label("About", systemImage: "info")
                }
            #endif
        }
        .accentColor(Color("brandPrimary"))
    }
}

#Preview {
    HomeScreen()
}
