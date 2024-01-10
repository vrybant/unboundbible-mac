//
//  TitlesView.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct TitlesView: View {
    @Environment(\.presentationMode) var presentation
    
    public var body: some View {
        
        let titles = currBible?.getTitles() ?? []
        
//        List(titles, id: \.self) { item in
//            Text(item)
//        }
        
        NavigationStack {
            List(titles, id: \.self) { title in
//              NavigationLink(player, value: player)
                
                NavigationLink(destination: ChaptersView(name: title)) {
                    Text(title)
                }
                
            }
//          .navigationDestination(for: String.self, destination: ChaptersView.init)
            .navigationTitle("Books")
        }

    }
}
