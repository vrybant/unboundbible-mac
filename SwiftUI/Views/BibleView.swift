//
//  Unbound Bible
//
//  Copyright © Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct BibleView: View {
    @ObservedObject var mainStore = MainStore.shared
    @ObservedObject var router = Router.shared
    
    public var body: some View {
        let list = mainStore.content
        let title = currBible!.verseToString(mainStore.verse, cutted: true)

        NavigationStack(path: $router.bibleRoutes) {
            List(list, id: \.self) { item in
                let attrString = parse(item)
                let content = AttributedString(attrString)
                Text(content)
                    .onTapGesture {
                        // print(item)
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(title!) {
                        router.bibleRoutes.append(.books)
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
