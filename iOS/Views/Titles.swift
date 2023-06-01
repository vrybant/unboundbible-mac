//
//  Titles.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct TitlesView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var buttonTitle: String
    let callback: (String) -> ()

    init(buttonTitle: String, callback: @escaping (String) -> ()) {
        _buttonTitle = State(initialValue: buttonTitle)
        self.callback = callback
    }

    var body: some View {
        Button("Button B") {
            buttonTitle = "Button B"
            presentationMode.wrappedValue.dismiss()
        }
        .onDisappear {
            callback(buttonTitle)
        }
    }
}
