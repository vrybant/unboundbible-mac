//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

struct BooksView: View {
    @State var selection: String?
    
    public var body: some View {
        let titles = currBible?.getTitles() ?? []
        
        List(titles, id: \.self, selection: $selection) { title in
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    BibleStore.shared.router.append(.chapters(title))
                }
        }
        .navigationTitle("Books")
        //.listRowBackground(Color.clear)
    }
    
}

#Preview {
    BooksView()
}
