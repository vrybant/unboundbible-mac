//
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct ChaptersView: View {
    let name: String

    var body: some View {
        let chaptersCount = currBible!.chaptersCount(currVerse)
        let chapters = 1...chaptersCount
        
        List(chapters, id: \.self) { item in
            Text("Глава \(item)")
                .onTapGesture {
                    print(item)
                }
        }

    }
}

