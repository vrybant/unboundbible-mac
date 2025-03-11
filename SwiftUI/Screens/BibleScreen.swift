//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

public struct BibleScreen: View {
    @State var store = BibleStore.shared
    @State var showDialog = false
    @State var selection: UUID? = nil

    public var body: some View {
        NavigationStack(path: $store.router) {
            List(store.content, selection: $selection) { item in
                let attrString = parse(item.string)
                let edgeInsets : EdgeInsets = .init(top: 7, leading: 15, bottom: 7, trailing: 15)
                Text(attrString)
                    .listRowInsets(edgeInsets)
                    .listRowSeparator(.hidden)
                    .font(.body)
                    .dynamicTypeSize(.xLarge)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                  .background(.red)
                    .onTapGesture {
                        selection = item.id
                        showDialog = true
                    }
                    .confirmationDialog("Change background", isPresented: $showDialog) {
                        Button("Копировать") {
                            selection = nil
                        }
                        Button("Сравнить") {
                            selection = nil
                        }
                        Button("Закладка") {
                            selection = nil
                        }
                        Button("Отмена", role: .cancel) {
                            selection = nil
                        }
                    } message: {
                        Text(store.title) // verse number
                    }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(store.title) {
                        store.router.append(.books)
                    }
                }
            }
            .navigationDestination(for: BibleRoute.self) { $0 }
            .safeNavigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    BibleScreen()
}
