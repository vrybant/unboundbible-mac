//
//  Unbound Bible
//
//  Copyright © Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct BibleView: View {
    
    private var mainStore = MainStore.shared
    private var router = Router.shared
    
    public var body: some View {
        
        @Bindable var router = router
        
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
