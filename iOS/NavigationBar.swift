//
//  NavigationBar.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct NavigationBar: View {
    
    @State private var centerText = ""
    @State private var showLeftAlert: Bool = false
    @State private var showRightAlert: Bool = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Text(centerText)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Left") {
                            centerText = "Left Button Clicked"
                            showLeftAlert = true
                        }.alert(isPresented: $showLeftAlert) {
                            Alert(title: Text("Left"), message: Text("Button Clicked"), dismissButton: .default(Text("Dismiss")))
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
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
    }
}


