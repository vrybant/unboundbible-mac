//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation
import Combine

class SearchStore: ObservableObject {
    static let shared = SearchStore()

    @Published var searchText = ""
    @Published var content: [String] = []

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
