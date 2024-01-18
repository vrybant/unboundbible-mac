//
//  Unbound Bible
//  Copyright © Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct ShelfView: View {
    @State private var selection: String?

    public var body: some View {
        let list = tools.get_Shelf()
        
        NavigationStack {
            List(list, id: \.self, selection: $selection) { item in
                HStack {
                    Text(item)
                        .onTapGesture {
                            print($selection)
                        }
                    Spacer()
                    let checked = item == currBible!.name
                    Image(systemName: checked ? "checkmark" : "")
                }

            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Modules")
//          .toolbar {
//              EditButton()
//          }
        }
    }
}

#Preview {
    ShelfView()
}
