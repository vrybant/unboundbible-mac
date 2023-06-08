//
//  List.swift
//  iOS
//
//  Created by Vladimir Rybant on 08.06.2023.
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct ListView: View {
    
    struct Ocean: Identifiable {
        let name: String
        let id = UUID()
    }
    
    private var oceans = [
        Ocean(name: "Pacific"),
        Ocean(name: "Atlantic"),
        Ocean(name: "Indian"),
        Ocean(name: "Southern"),
        Ocean(name: "Arctic")
    ]

    public var body: some View {
        List(oceans) {
            Text($0.name)
        }
    }
}
