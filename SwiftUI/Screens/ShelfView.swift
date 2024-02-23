//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

public struct ShelfView: View {
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
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Modules")
            }
        }
    }
}

#Preview {
    ShelfView()
}
