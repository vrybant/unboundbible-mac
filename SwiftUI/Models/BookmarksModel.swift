//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

@Observable class BookmarksModel {
    static let shared = BookmarksModel()

    var content = ["1","2","3"].identifiable

    private init() {}

    func update(_ bookmark: IdentifiableString) {
//      content = []
        content.append(bookmark)
    }

}
