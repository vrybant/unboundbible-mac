//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

struct BooksView: View {
    @State var selection: Title?
    @State var newtestament: Bool = currVerse.book >= 40
    @State var isButtonVisible = true

    public var body: some View {
        let items : [Title] = currBible?.getTitles() ?? []
        let first = items.first
        let matthew = items.first { $0.id == 40 }
        
        ScrollViewReader { proxy in
            ZStack(alignment: .bottomTrailing) {
                List(items, id: \.self, selection: $selection) { item in
                    Text(item.string)
                        .id(item)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print("onTapGesture")
                            handleAction(for: item)
                        }
                        .onLongPressGesture {
                            print("onLongPressGesture")
                            handleAction(for: item)
                        }
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
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button(action: {
//                            newtestament = !newtestament
//                            let id = newtestament ? matthew : first
//                            if let id = id {
//                                withAnimation {
//                                    proxy.scrollTo(id, anchor: .top)
//                                }
//                            }
//                        }) {
//                            Image(systemName: newtestament ? "arrow.up" : "arrow.down")
//                        }
//                    }
//                }
#endif
                if isButtonVisible {
                    Button {
                        Task {
                            isButtonVisible = false
                            try? await Task.sleep(for: .seconds(0.2))
                            isButtonVisible = true
                        }
                        newtestament = !newtestament
                        if let id = newtestament ? matthew : first {
                            withAnimation {
                                proxy.scrollTo(id, anchor: .top)
                            }
                        }
                    } label: {
                        Image(systemName: newtestament ? "chevron.up" : "chevron.down")
                            .font(.title2)
                            .foregroundStyle(.black)
                            .frame(width: 40, height: 40)
                            .background(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
                
            }
        }
    }
    
    private func handleAction(for item: Title) {
        selection = item
        BibleModel.shared.route.append(.chapters(item.string))
        selection = nil
        Task {
            try? await Task.sleep(for: .seconds(0.1))
        }
    }
    
}

#Preview {
    BooksView()
}
