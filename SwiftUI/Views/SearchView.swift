//
//  SearchView.swift
//  SwiftUI
//
//  Created by Vladimir Rybant on 16.01.2024.
//  Copyright © 2024 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct SearchDetail: View {
    @Environment(Router.self) private var router

    let name: String
    
    var body: some View {
        Button("Search Detail \(name)") {
            //router.searchRoutes.append(.home)
            router.searchRoutes.removeAll()
        }
    }
}

struct SearchView: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        
        @Bindable var router = router
        
        NavigationStack(path: $router.searchRoutes) {
            Text("***")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Button("Go to detail") {
                            router.searchRoutes.append(.detail("anystring"))
                        }
                    }
                }
//            Button("Go to detail") {
//                // async function
//                router.searchRoutes.append(.detail("anystring"))
//            }
            .navigationDestination(for: SearchRoute.self) { route in
                switch route {
                    case .home:
                        Text("Home")
                    case .detail(let name):
                        SearchDetail(name: name)
                }
            }
        }
        
    }
}

#Preview {
    SearchView()
        .environment(Router())
}
