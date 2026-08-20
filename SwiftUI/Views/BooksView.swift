//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

var selected: Title? = nil // workaround
var newt = false

struct BooksView: View {
    @State var selection: Title? = selected
    
    func scroll(_ proxy: ScrollViewProxy, item: Title?) {
        if let item = item {
            Task { @MainActor in
                await Task.yield()
                withAnimation {
                    proxy.scrollTo(item, anchor: .top)
                }
            }
        }
    }
    
    public var body: some View {
        let items : [Title] = currBible?.getTitles() ?? []
        let matthew = items.first { $0.id == 40 }
        
        ScrollViewReader { proxy in
            List(items, id: \.self, selection: $selection) { item in
                Text(item.string)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selection = item
                        selected = selection
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            if let selection = selection {
                                newt = selection.id >= 40
                                BibleModel.shared.route.append(.chapters(selection.string))
                            }
                        }
                    }
//                    .onLongPressGesture {
//                        selection = item.id
//                        BibleModel.shared.router.append(.chapters(item.))
//                    }
//                    .onChange(of: selection) {
//                        print("List changed. Selected item is: \(selection ?? "None")")
//                        withAnimation {
//                            proxy.scrollTo(newValue, anchor: .center)
//                        }
//                    }
                
                
            }
 //         .padding(.top, -20)
            .listStyle(.plain)
            .navigationTitle("Books")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if let matthew = matthew {
                            proxy.scrollTo(matthew, anchor: .top)
                        }
                    }) {
                        Image(systemName: "arrow.down.circle")
                    }
                }
                #endif
            }
            .onAppear {
                if newt {
                    scroll(proxy, item: matthew)
                }
            }
            
            Button("Scroll") {
                withAnimation {
                    proxy.scrollTo(1, anchor: .top)
                }
            }
            
        }
    }
    
}

#Preview {
    BooksView()
}
