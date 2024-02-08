//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

struct BooksView: View {
    
    public var body: some View {
        let titles = currBible?.getTitles() ?? []
        
        List(titles, id: \.self) { title in
            Button(title) {
                BibleStore.shared.router.append(.chapters(title))
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Books")
    }
    
}

#Preview {
    BooksView()
}
