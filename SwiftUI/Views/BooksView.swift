//
//  TitlesView.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct BooksView: View {
    @Environment(\.presentationMode) var presentation
    
    public var body: some View {
        let titles = currBible?.getTitles() ?? []
                
        NavigationStack {
            List(titles, id: \.self) { title in
                NavigationLink(destination: ChaptersView(name: title)) {
                    Text(title)
                        .onTapGesture {
                            print(title)
                        }
                }
                
            }
//          .navigationDestination(for: String.self, destination: ChaptersView.init)
            .navigationTitle("Books")
        }
    }
}
