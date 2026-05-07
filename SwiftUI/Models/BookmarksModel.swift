//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

@Observable class BookmarksModel {
    static let shared = BookmarksModel()

    var content = [RowData]()

    private init() {}

    func update(_ bookmark: RowData) {
        content.append(bookmark)
    }

}
