//
//  Unbound Bible
//
//  Copyright © Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct BooksView: View {
    
    public var body: some View {
        let titles = currBible?.getTitles() ?? []
        
        List(titles, id: \.self) { title in
            Button(title) {
                Router.shared.bibleRoutes.append(.chapters(title))
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Books")
    }
    
}

#Preview {
    BooksView()
}
