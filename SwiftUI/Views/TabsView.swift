//
//  SwiftUI
//  Copyright © Vladimir Rybant. All rights reserved.
//

import SwiftUI

enum AppTabs: Hashable, Identifiable, CaseIterable {
    
    case bible
    case search
    case modules
    
    var id: AppTabs { self }
}

extension AppTabs {
    
    @ViewBuilder
    var label: some View {
        switch self {
        case .bible:
            Label("Bible", systemImage: "book")
        case .search:
            Label("Search", systemImage: "magnifyingglass")
        case .modules:
            Label("Modules", systemImage: "books.vertical")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .bible: 
                BibleView()
            case .search: 
                SearchView()
            case .modules: 
                ShelfView()
        }
    }
}

struct TabsView: View {
    
    @Binding var selection: AppTabs?
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppTabs.allCases) { tab in
                tab.destination
                    .tag(tab as AppTabs?)
                    .tabItem {
                        tab.label
                    }
            }
        }
    }
}
