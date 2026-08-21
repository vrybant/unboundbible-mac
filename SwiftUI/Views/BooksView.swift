//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

struct BooksView: View {
    @State var selection: Title?
    @State var newtestament: Bool = currVerse.book >= 40

    public var body: some View {
        let items : [Title] = currBible?.getTitles() ?? []
        let first = items.first
        let matthew = items.first { $0.id == 40 }
        
        ScrollViewReader { proxy in
            List(items, id: \.self, selection: $selection) { item in
                Text(item.string)
                    .id(item)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selection = item
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            if let selection = selection {
                                BibleModel.shared.route.append(.chapters(selection.string))
                            }
                        }
                    }
//                  .onLongPressGesture
            }
//          .padding(.top, -20)
            .listStyle(.plain)
            .navigationTitle("Books")
            .onAppear {
                if newtestament {
                    Task { @MainActor in
                        await Task.yield()
                        proxy.scrollTo(matthew, anchor: .top)
                    }
                }
            }
            #if os(iOS)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        newtestament = !newtestament
                        let id = newtestament ? matthew : first
                        if let id = id {
                            withAnimation {
                                proxy.scrollTo(id, anchor: .top)
                            }
                        }
                    }) {
                        Image(systemName: newtestament ? "arrow.up.circle" : "arrow.down.circle")
                    }
                }
            }
            #endif
        }
    }
    
}

#Preview {
    BooksView()
}
