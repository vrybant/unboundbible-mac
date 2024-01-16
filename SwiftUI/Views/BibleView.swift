//
//  NavigationBar.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct BibleView: View {
    
    @Environment(Router.self) private var router
    
    @State private var centerText = ""
    @State private var showLeftAlert: Bool = false
    @State private var showRightAlert: Bool = false

    public var body: some View {
        
        @Bindable var router = router

        NavigationStack(path: $router.bibleRoutes) {
            ScriprureView()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button("Bible") {
                        router.bibleRoutes.append(.books)
                    }
                }
            }
            .navigationDestination(for: BibleRoute.self) { route in
                switch route {
                    case .books:
                        BooksView()
                    case .chapters(let name):
                        ChaptersView(name: name)
                }
            }
        }
        
    }
}
