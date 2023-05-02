//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation

extension Array where Element == URL {
    var bookmarks : [Data] {
        var result : [Data] = []
        for url in self {
            if let bookmark = try? url.bookmarkData( /* options: .securityScopeAllowOnlyReadAccess, */ includingResourceValuesForKeys: nil, relativeTo: nil) {
                result.append(bookmark)
            }
        }
        return result
    }
    
    mutating func append(bookmarks: [Data]) {
        for bookmark in bookmarks {
            if let url = try? NSURL.init(resolvingBookmarkData: bookmark, options: .withoutUI, relativeTo: nil, bookmarkDataIsStale: nil) {
                url.startAccessingSecurityScopedResource()
                self.append(url as URL)
            }
        }
    }
}
