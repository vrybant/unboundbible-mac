//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import SwiftUI

public struct ShelfScreen: View {
    @State var appModel = AppModel.shared
    @State var selection: UUID? = nil
    
    var content: [IdentifiableString] { tools.get_Shelf().identifiable }
   
    func isCurrent(name: String) -> Bool {
        name == currBible.name
    }

    func onTap(_ item: IdentifiableString) {
        let bible = item.string
        tools.setCurrBible(bible)
        HomeModel.shared.route = HomeRoute.bible
    }

    public var body: some View {
        NavigationStack {
            VStack {
                List(content, selection: $selection) { item in
                    HStack {
                        Text(item.string)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(isCurrent(name: item.string) ? 1.0 : 0.0)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selection = item.id
                        onTap(item)
                    }
                }
                .padding(.top, -20)
                .navigationTitle("Modules")
//              .onAppear {
//                  selection = content.first // Set default selection
//              }
                .safeNavigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    ShelfScreen()
}
