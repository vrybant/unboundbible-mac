//
//  SwiftUI
//  Copyright © Vladimir Rybant. All rights reserved.
//

import SwiftUI

enum Tabs: Identifiable {
    case bible
    case search
    case modules
    
    var id: Tabs { self }
}

struct TabsView: View {
    @State var selection = Tabs.bible
    
    var body: some View {
        TabView(selection: $selection) {
            BibleView()
                .tag(Tabs.bible)
                .tabItem {
                    Label("Bible", systemImage: "book")
                }
            SearchView()
                .tag(Tabs.bible)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            ShelfView()
                .tag(Tabs.bible)
                .tabItem {
                    Label("Modules", systemImage: "books.vertical")
                }
        }
    }
}

#Preview {
    TabsView()
}
