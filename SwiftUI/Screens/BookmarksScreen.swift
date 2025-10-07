//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

struct BookmarksScreen: View {
    var model = BookmarksModel.shared
        
    var body: some View {
        NavigationStack {
            List(model.content) { item in
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
