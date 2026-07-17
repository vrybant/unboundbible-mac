//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

@Observable class BookmarksModel {
    static let shared = BookmarksModel()
    var content: [RowData] = UserDefaults.standard.rowData(forKey: "bookmarks")
    
    func update(_ bookmark: RowData) {
        content.append(bookmark)
        UserDefaults.standard.set(content, forKey: "bookmarks")
    }

}
