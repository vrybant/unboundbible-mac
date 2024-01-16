//
//  TitlesView.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct BooksView: View {
    @Environment(Router.self) private var router
    
    public var body: some View {
        let titles = currBible?.getTitles() ?? []
        
        List(titles, id: \.self) { title in
            Button(title) {
                print(title)
                router.bibleRoutes.append(.chapters(title))
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Books")
    }
    
}

#Preview {
    BooksView()
        .environment(Router())
}
