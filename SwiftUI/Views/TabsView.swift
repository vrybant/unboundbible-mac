//
//  TabsView.swift
//  SwiftUI
//
//  Created by Vladimir Rybant on 15.01.2024.
//  Copyright © 2024 Vladimir Rybant. All rights reserved.
//

import SwiftUI

enum AppTabs: Hashable, Identifiable, CaseIterable {
    
    case bible
    case search
    case modules
    
    var id: AppTabs { self }
    
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
        case .bible: BibleView()
        case .search: Text("Search")
        case .modules: ModulesView()
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
