//
//  ContentView.swift
//  iOS
//
//  Created by Vladimir Rybant on 22/11/2021.
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            
            List(0..<tools.get_Chapter().count) { item in
                Text(tools.get_Chapter()[item])
                    .padding()
            }
            .tabItem {
                Text("Bible")
                Image(systemName: "tv.fill")
             }

/*
            Text(tools.get_Chapter().joined(separator: "\n"))
             .padding()
             .tabItem {
                Image(systemName: "tv.fill")
                Text("Bible")
 */
              
           Text("Search Tab")
             .tabItem {
                Image(systemName: "phone.fill")
                Text("Search")
              }
        }
        /*
        Text(tools.get_Chapter().joined(separator: "\n"))
            .padding()
        */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
