//
//  Unbound Bible
//
//  Copyright © Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct BibleView: View {
    
    private var router = Router.shared
    
    @State private var centerText = ""
    @State private var showLeftAlert: Bool = false
    @State private var showRightAlert: Bool = false
    
    public var body: some View {
        
        @Bindable var router = router
        
        let list = tools.get_Chapter()
        let title = currBible!.verseToString(currVerse, cutted: true)

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
