//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

struct HomeScreen: View {
    @State var model = HomeModel.shared
    
    var body: some View {
        TabView(selection: $model.selection) {
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
            
            #if canImport(UIKit)
            if UIDevice.current.userInterfaceIdiom == .phone {
                OptionsScreen()
                    .tag(HomeRoute.options)
                    .tabItem {
                        Label("Options", systemImage: "gear")
                    }
            }
            #endif
        }
        .accentColor(Color("brandPrimary"))
    }
}

#Preview {
    HomeScreen()
}
