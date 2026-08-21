//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

struct BooksView: View {
    @State var selection: Title?
    @State var newt: Bool = false

    func scroll(_ proxy: ScrollViewProxy, id: Title?, animation: Bool) {
        if let id = id {
            Task { @MainActor in
                await Task.yield()
                let animation = animation ? Animation.default : nil
                withAnimation(animation) {
                    proxy.scrollTo(id, anchor: .top)
                }
            }
        }
    }
    
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
                                newt = selection.id >= 40
                                BibleModel.shared.route.append(.chapters(selection.string))
                            }
                        }
                    }
//                  .onLongPressGesture
            }
 //         .padding(.top, -20)
            .listStyle(.plain)
            .navigationTitle("Books")
            .onAppear {
                if newt {
                    scroll(proxy, id: matthew, animation: false)
                }
            }
            
            #if os(iOS)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        newt = !newt
                        let id = newt ? matthew : first
                        scroll(proxy, id: id, animation: true)
                        
//                        if let id = id {
//                            withAnimation {
//                                proxy.scrollTo(id, anchor: .top)
//                            }
//                        }
                        
                    }) {
                        Image(systemName: newt ? "arrow.up.circle" : "arrow.down.circle")
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
