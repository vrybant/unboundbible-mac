//
//  ShelfView.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct ShelfView: View {

    public var body: some View {
        let titles = tools.get_Shelf()
        
        List(titles, id: \.self) { item in
            Text(item)
        }
    }
}
