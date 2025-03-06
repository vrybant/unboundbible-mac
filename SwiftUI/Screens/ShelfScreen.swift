//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

public struct ShelfScreen: View {
    var store = ShelfStore.shared
    
    public var body: some View {
        NavigationStack {
            VStack {
                List(store.content, id: \.self) { item in
                    HStack {
                        Text(item)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                store.update(bible: item)
                            }
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(store.isCurrent(name: item) ? 1.0 : 0.0)
                    }
                }
                .navigationTitle("Modules")
                .safeNavigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    ShelfScreen()
}
