//
//  DetailView.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var userBuy: UserBuy
    
    let color: String
    var body: some View {
        VStack {
            Text("Купить \(userBuy.caps) ") //.padding()
//              .navigationBarTitle(Text(color), displayMode: .inline)
                .navigationBarItems(leading:
                    Button("назад") {
                        presentation.wrappedValue.dismiss()
                    }
                , trailing:
                    Button(" + ") {
                        userBuy.caps += 1
                    }
                )
        }
        .navigationBarBackButtonHidden(true)
        
//      .onAppear() {
//          userBuy.caps = 0
//      }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    @available(iOS 13.0, *)
    static var previews: some View {
        DetailView(color: "Red")
    }
}
