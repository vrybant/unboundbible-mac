//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

@Observable class SearchModel {

    @ObservationIgnored var searchText = ""
    var content: [SearchItem] = []

    func update(text: String) {
        searchText = text
        content = searchText.isEmpty ? [] : tools.get_Search(string: searchText)
    }

}
