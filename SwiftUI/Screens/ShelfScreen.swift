//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

public struct ShelfScreen: View {
    @State var selection: UUID? = nil
    
    var store = ShelfStore.shared
    let content = ShelfStore.shared.content
    
    public var body: some View {
        NavigationStack {
            VStack {
                List(content, selection: $selection) { item in
                    HStack {
                        Text(item.string)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(store.isCurrent(name: item.string) ? 1.0 : 0.0)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selection = item.id
                        store.update(bible: item.string)
                    }
                }
                .padding(.top, -20)
                .navigationTitle("Modules")
//              .onAppear {
//                  selection = content.first // Set default selection
//              }
                .safeNavigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    ShelfScreen()
}
