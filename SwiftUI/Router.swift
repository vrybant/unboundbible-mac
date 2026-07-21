//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

enum HomeRoute {
    case bible
    case search
    case shelf
    case bookmarks
    case options
}

enum BibleRoute: Hashable, View {
    case books
    case chapters(String)
    
    var body: some View {
        switch self {
            case .books:
                BooksView()
            case .chapters(let name):
                ChaptersView(name: name)
        }
    }
}
