//
//  Unbound Bible
//
//  Copyright © Vladimir Rybant. All rights reserved.
//

// isPresented https://medium.com/@fsamuelsmartins/how-to-use-the-swiftuis-navigationstack-79f32ada7c69

import SwiftUI
import Combine

enum BibleRoute: Hashable {
    case books
    case chapters(String)
}

enum SearchRoute: Hashable {
    case home
    case detail(String)
}

extension BibleRoute: View {
    
    var body: some View {
        switch self {
            case .books:
                BooksView()
            case .chapters(let name):
                ChaptersView(name: name)
        }
    }
    
}

class Router: ObservableObject {
    static let shared = Router()
    
    init() {}
    
    @Published var bibleRoutes: [BibleRoute] = []
    @Published var searchRoutes: [SearchRoute] = []
}
