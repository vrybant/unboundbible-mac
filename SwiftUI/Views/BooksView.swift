//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

var selected: String? // workaround

struct BooksView: View {
    @State var selection: String? = selected
    
    public var body: some View {
        let items = currBible?.getTitles() ?? []
        
        ScrollViewReader { proxy in
            List(items, id: \.self, selection: $selection) { item in
                Text(item)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selection = item
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
            .onAppear {
                if let selection = selection {
                    proxy.scrollTo(selection, anchor: .center)
                }
            }
        }
    }
    
}

#Preview {
    BooksView()
}
