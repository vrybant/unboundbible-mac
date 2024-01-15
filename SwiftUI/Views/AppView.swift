//
//  AppView.swift
//  SwiftUI
//
//  Copyright © Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    @State private var selection: AppTabs? = .bible
    
    var body: some View {
        TabsView(selection: $selection)
    }
}

#Preview {
    AppView()
}
