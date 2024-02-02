//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

struct BookmarksView: View {
    @ObservedObject var store = BookmarksStore.shared
        
    var body: some View {
        NavigationStack {
            List (store.content, id: \.self) { item in
                let attrString = parse(item)
                let content = AttributedString(attrString)
                Text(content)
            }
            .navigationTitle("Bookmarks")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    BookmarksView()
}
