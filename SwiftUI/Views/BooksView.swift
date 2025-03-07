//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

struct BooksView: View {
    @State var selection: String? = nil
    
    public var body: some View {
        let titles = currBible?.getTitles() ?? []
        
        List(titles, id: \.self, selection: $selection) { title in
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    selection = title
                    BibleStore.shared.router.append(.chapters(title))
                }
                .onLongPressGesture {
                    selection = title
                    BibleStore.shared.router.append(.chapters(title))
                }
            
        }
        .padding(.top, -20)
        .navigationTitle("Books")
    }
    
}

#Preview {
    BooksView()
}
