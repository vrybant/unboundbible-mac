//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

private struct ListItem: Identifiable {
    var name: String
    var checked: Bool = false
    let id = UUID() // Universal Unique Identifier
}

private func preview() -> [ListItem] {
    var result = [ListItem]()
    let list = ShelfStore.shared.content
    for item in list {
        let checked = item == currBible!.name
        result.append(ListItem(name: item, checked: checked))
    }
    return result
}

public struct ShelfView: View {
    @State private var list = preview()

    public var body: some View {
        NavigationStack {
            VStack {
                List(list) { item in
                    HStack {
                        Text(item.name)
                            .onTapGesture {
                                ShelfStore.shared.update(bible: item.name)
                                list = preview()
                            }
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(item.checked ? 1.0 : 0.0)
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
