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
    
    @State private var showSheet = false
    @State private var buttonTitle = "Библия"
    
    
    public var body: some View {
        NavigationView {
            Text("Text")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: DetailView()) {
                            Text("Left")
                        }
                    }
                                        
                    ToolbarItem(placement: .principal) {
                        Button {
                            showSheet.toggle()
                        } label: {
//                          Text(buttonTitle)
                            Text("Библия")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .buttonStyle(.borderedProminent)

                        .sheet(isPresented: $showSheet) {
                            TitlesView(buttonTitle: buttonTitle) {
                                self.buttonTitle = $0
                            }
                        }
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

//struct NavigationBar_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationBar()
//    }
//}


