//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

struct BookmarksScreen: View {
    var bookmarksModel = BookmarksModel.shared
        
    var body: some View {
        NavigationStack {
            List(bookmarksModel.content) { item in
                let attrString = parse(item.string)
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
