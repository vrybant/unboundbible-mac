//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

var selected: String? // workaround

struct BooksView: View {
    @State var selection: String? = selected
    
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
                        selection = item.string
                        selected = selection
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            BibleModel.shared.route.append(.chapters(selection!))
                        }
                    }
//                    .onLongPressGesture {
//                        selection = item.id
//                        BibleModel.shared.router.append(.chapters(item.))
//                    }
                    .onChange(of: selection) {
//                        print("List changed. Selected item is: \(selection ?? "None")")
//                        withAnimation {
//                            proxy.scrollTo(newValue, anchor: .center)
//                        }
                    }
                
                
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
                    proxy.scrollTo(selection, anchor: .center)
                }
            }
            
            Button("Scroll") {
                    withAnimation {
//                        let id = 40
                        proxy.scrollTo(1, anchor: .top)
//                      proxy.scrollTo(last.id, anchor: .bottom)
                    }
            }
            
        }
    }
    
}

#Preview {
    BooksView()
}
