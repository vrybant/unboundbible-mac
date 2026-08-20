//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

var selected: Title? = nil // workaround

struct BooksView: View {
    @State var selection: Title? = selected
    
    func onToolbarTap(_ proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo(40, anchor: .top)
        }
    }

    public var body: some View {
        let items : [Title] = currBible?.getTitles() ?? []
        
        ScrollViewReader { proxy in
            List(items, id: \.id, selection: $selection) { item in
                Text(item.string)
//                    .id(item)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selection = item
                        selected = selection
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            if let selection = selection {
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
            .padding(.top, -20)
            .navigationTitle("Books")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { onToolbarTap(proxy) }) {
                        Image(systemName: "arrow.down.circle")
                    }
                }
                #endif
            }
            .onAppear {
                if let selection = selection {
                    Task { @MainActor in
                        await Task.yield()
                        withAnimation {
                            proxy.scrollTo(selection.id, anchor: .center)
                        }
                    }
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
