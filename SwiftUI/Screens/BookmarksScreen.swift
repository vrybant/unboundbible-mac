//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

struct BookmarksScreen: View {
    var store = BookmarksStore.shared
        
    var body: some View {
        NavigationStack {
            List (store.content, id: \.self) { item in
                let attrString = parse(item)
                Text(attrString)
            }
            .padding(.top, -20)
            .navigationTitle("Bookmarks")
            .safeNavigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    BookmarksScreen()
}
