//
//  ContentView.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationBar()
    }
}

struct ContenttttView: View {
    @State private var show = true
    
    var body: some View {
        VStack {
            Toggle(isOn: $show) {
                Text("Hello, world!")
            }
            .padding()
            
            if show {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
