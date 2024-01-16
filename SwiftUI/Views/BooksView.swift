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
            Text(title)
                .onTapGesture {
                    print(title)
                    router.bibleRoutes.append(.chapters(title))
                }
        }
        .navigationTitle("Books")
    }
    
}
