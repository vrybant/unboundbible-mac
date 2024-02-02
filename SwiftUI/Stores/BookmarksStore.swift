//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation
import Combine

class BookmarksStore: ObservableObject {
    static let shared = BookmarksStore()

    @Published var content: [String] = ["1","2","3"]

    private init() {}

    func update() {
        content = []
    }

}
