//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

struct SearchItem: Identifiable {
    let link: String
    let string: String
    let id = UUID()
}

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
        content = []
        let searchResult = tools.get_Search(string: searchText).strings
        for s in searchResult {
            let components = s.components(separatedBy: "</l> ")
            let item = SearchItem(link: components[0], string: components[1])
            content.append(item)
        }
    }
    
    func searchResult(text: String) -> [String] {
        if text.count < 2 { return [] }
        let data = tools.get_Search(string: text).strings
        return data
    }

}
