//
//  ListView.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

// https://developer.apple.com/tutorials/swiftui/building-lists-and-navigation

import SwiftUI

public struct ListView: View {

    public var body: some View {
        
        let titles = tools.get_Chapter()
        
        List(titles, id: \.self) { item in
            Text(item)
                .onTapGesture {
                    print(item)
                }
        }
    }
}
