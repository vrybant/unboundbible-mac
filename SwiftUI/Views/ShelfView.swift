//
//  Unbound Bible
//  Copyright © Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct ShelfView: View {
    @State private var selection: String?

    public var body: some View {
        let titles = tools.get_Shelf()
        
        NavigationStack {
            List(titles, id: \.self, selection: $selection) { item in
                HStack {
                    Text(item)
                        .onTapGesture {
                            print($selection)
                        }
                    Spacer()
                    Image(systemName: "checkmark")
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
