//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

struct BooksView: View {
    @State var selection: UUID? = nil
    
    public var body: some View {
        let titles = currBible?.getTitles() ?? []
        let content = titles.identifiable
        
        List(content, selection: $selection) { item in
            Text(item.string)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    selection = item.id
                    BibleStore.shared.router.append(.chapters(item.string))
                }
                .onLongPressGesture {
                    selection = item.id
                    BibleStore.shared.router.append(.chapters(item.string))
                }
            
        }
        .padding(.top, -20)
        .navigationTitle("Books")
    }
    
}

#Preview {
    BooksView()
}
