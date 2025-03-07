//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

public struct BibleScreen: View {
    @State var store = BibleStore.shared
    @State var showDialog = false
    @State var selection: String? = nil

    public var body: some View {
        NavigationStack(path: $store.router) {
            List(store.content, id: \.self, selection: $selection) { item in
                let attrString = parse(item)
                let content = AttributedString(attrString)
                let edgeInsets : EdgeInsets = .init(top: 5, leading: 15, bottom: 5, trailing: 15)
                Text(content)
                    .listRowInsets(edgeInsets)
                    .listRowSeparator(.hidden)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                  .background(.red)
                    .onTapGesture {
                        selection = item
                        showDialog = true
                    }
                    .confirmationDialog("Change background", isPresented: $showDialog) {
                        Button("Копировать") {
                            print("copy")
                            selection = nil
                        }
                        Button("Сравнить") {
                            print("compare")
                            selection = nil
                        }
                        Button("Закладка") {
                            print("bookmark")
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
