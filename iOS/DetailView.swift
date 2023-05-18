//
//  DetailView.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    let color: String

    var body: some View {
        Text(color).padding()
            .navigationBarTitle(Text(color), displayMode: .inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    @available(iOS 13.0, *)
    static var previews: some View {
        DetailView(color: "Red")
    }
}
