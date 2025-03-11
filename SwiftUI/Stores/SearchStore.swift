//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

@Observable class SearchStore {
    static let shared = SearchStore()
    var searchText = ""
    var content: [SearchItem] = []

    private init() {}

    func update(text: String) {
        searchText = text
        update()
    }

    func update() {
        content = tools.get_Search(string: searchText)
    }
    
}
