//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

public struct ShelfScreen: View {
    @ObservedObject var store = ShelfStore.shared

    public var body: some View {
        NavigationStack {
            VStack {
                List(store.content, id: \.self) { item in
                    HStack {
                        Text(item)
                            .onTapGesture {
                                store.update(bible: item)
                            }
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(store.isCurrent(name: item) ? 1.0 : 0.0)
                    }
                }
                .navigationTitle("Modules")
                #if !os(macOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
            }
        }
    }
}

#Preview {
    ShelfScreen()
}
