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
                List(store.content) { item in
                    HStack {
                        Text(item.string)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                store.update(bible: item.string)
                            }
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(store.isCurrent(name: item.string) ? 1.0 : 0.0)
                    }
                }
                .padding(.top, -20)
                .navigationTitle("Modules")
                .safeNavigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    ShelfScreen()
}
