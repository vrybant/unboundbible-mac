//
//  Unbound Bible
//  Copyright © Vladimir Rybant. 
//

import SwiftUI

public struct BibleView: View {
    @ObservedObject var store = BibleStore.shared
    @State var showDialog = false
    
    public var body: some View {
        NavigationStack(path: $store.router) {
            List(store.content, id: \.self) { item in
                let attrString = parse(item)
                let content = AttributedString(attrString)
                Text(content)
                    .onTapGesture {
                        showDialog = true
                    }
                    .confirmationDialog("Change background", isPresented: $showDialog) {
                        Button("Копировать") {
                            print("copy")
                        }
                        Button("Сравнить") {
                            print("compare")
                        }
                        Button("Закладка") {
                            print("bookmark")
                        }
                        Button("Отмена", role: .cancel) { }
                    } message: {
                        Text(store.title) // verse number
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(store.title) {
                        store.router.append(.books)
                    }
                }
            }
            .navigationDestination(for: BibleRoute.self) { $0 }
        }
        
    }
}

#Preview {
    BibleView()
}
