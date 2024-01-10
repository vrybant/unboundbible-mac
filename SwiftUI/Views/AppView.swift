//
//  AppView.swift
//  SwiftUI
//
//  Copyright © Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            NavigationBar()
                .tag("bible")
                .tabItem {
                    Image(systemName: "book")
                }
            Text("Search")
                .tag("search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            Text("Modules")
                .tag("modules")
                .tabItem {
                    Image(systemName: "books.vertical")
                }
        }
    }
}

#Preview {
    AppView()
}
