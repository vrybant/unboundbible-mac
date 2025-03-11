//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

@Observable class BookmarksStore {
    static let shared = BookmarksStore()

    var content = ["1","2","3"].identifiable

    private init() {}

    func update() {
        content = []
    }

}
