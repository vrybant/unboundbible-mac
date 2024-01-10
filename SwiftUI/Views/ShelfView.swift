//
//  ShelfView.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct ShelfView: View {
    @State private var selection: String?

    public var body: some View {
        let titles = tools.get_Shelf()
        
        NavigationStack {
            List(titles, id: \.self, selection: $selection) { item in
                Text(item)
                    .onTapGesture {
                       print(item)
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Modules")
//          .toolbar {
//              EditButton()
//          }
        }
    }
}
