//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

@Observable class BookmarksModel {
    static let shared = BookmarksModel()

    var content = [].identifiable

    private init() {}

    func update(_ bookmark: IdentifiableString) {
//      content = []
        content.append(bookmark)
    }

}
