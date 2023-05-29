//
//  NavigationBar.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct NavigationBar: View {
    @EnvironmentObject var userBuy: UserBuy
    
    @State private var centerText = ""
    @State private var showLeftAlert: Bool = false
    @State private var showRightAlert: Bool = false
    
    public var body: some View {
        NavigationView {
            Text("\(centerText) \(userBuy.caps)")
                //.navigationBarTitle("BarTitle")
                .navigationBarTitleDisplayMode(.inline)

                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: DetailView(color: "color")) {
                            Text("Left")
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Button() {
                            centerText = ""
                            print("Tapped")
                        } label: {
                            Text("Библия")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .buttonStyle(.borderedProminent)
//                      .controlSize(.small)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Right") {
                            centerText = "Right Button Clicked"
                            showRightAlert = true
                        }.alert(isPresented: $showRightAlert) {
                            Alert(title: Text("Right"), message: Text("Button Clicked"), dismissButton: .default(Text("Dismiss")))
                        }
                    }
                }
         }
        .environmentObject(userBuy)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
    }
}


