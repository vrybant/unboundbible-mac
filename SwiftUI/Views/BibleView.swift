//
//  NavigationBar.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct BibleView: View {
//  @EnvironmentObject var userBuy: UserBuy
    
    @State private var centerText = ""
    @State private var showLeftAlert: Bool = false
    @State private var showRightAlert: Bool = false
    
    public var body: some View {
        NavigationStack {
            ScriprureView()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    NavigationLink(destination: BooksView()) {
                        Text("Bible")
                    }
                }
                
            }
        }
    }
}
