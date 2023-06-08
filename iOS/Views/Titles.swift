//
//  Titles.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct TitlesView: View {
    @Environment(\.presentationMode) var presentation

    struct Title: Identifiable {
        let name: String
        let id = UUID()
    }
    
    private var titles = [
        Title(name: "Genesis"),
        Title(name: "Exodus"),
        Title(name: "Leviticus"),
        Title(name: "Numbers"),
        Title(name: "Deuteronomy"),
        Title(name: "Joshua"),
        Title(name: "Judges"),
        Title(name: "Ruth"),
        Title(name: "1 Samuel"),
        Title(name: "2 Samuel")
    ]

    public var body: some View {
        List(titles) {
            Text($0.name)
        }
//      .navigationBarBackButtonHidden(true)
    }
}
