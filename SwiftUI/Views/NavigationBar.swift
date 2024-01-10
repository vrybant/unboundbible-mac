//
//  NavigationBar.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct NavigationBar: View {
//  @EnvironmentObject var userBuy: UserBuy
    
    @State private var centerText = ""
    @State private var showLeftAlert: Bool = false
    @State private var showRightAlert: Bool = false
    
    public var body: some View {
        NavigationStack {
            ListView()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: TitlesView()) {
                        Text("Titles")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    NavigationLink(destination: DetailView()) {
                        Text("Bible")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ShelfView()) {
                        Text("Shelf")
                    }
                }
            }
        }
    }
}
