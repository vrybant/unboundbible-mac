//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

@Observable
class BookmarksModel {
    static let shared = BookmarksModel()
    
    var content: [RowData] = userDefaults.rowDataList(forKey: "bookmarks") {
        didSet {
            UserDefaults.standard.set(content, forKey: "bookmarks")
        }
    }
    
}
