//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

@Observable class BookmarksStore {
    static let shared = BookmarksStore()

    var content: [String] = ["1","2","3"]

    private init() {}

    func update() {
        content = []
    }

}
