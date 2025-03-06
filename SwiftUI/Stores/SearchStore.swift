//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

@Observable class SearchStore {
    static let shared = SearchStore()

    var searchText = ""
    var content: [String] = []

    private init() {}

    func update(text: String) {
        searchText = text
        update()
    }

    func update() {
        content = tools.get_Search(string: searchText).strings
    }
    
    func searchResult(text: String) -> [String] {
        if text.count < 2 { return [] }
        let data = tools.get_Search(string: text).strings
        return data
    }

}
