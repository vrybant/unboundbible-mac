//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

@Observable
class ShelfModel {
    static let shared = ShelfModel()
    
    var content = tools.get_Shelf().identifiable

    private init() {}

    func update(bible: String) {
        tools.setCurrBible(bible)
        content = tools.get_Shelf().identifiable
    }
    
    func isCurrent(name: String) -> Bool {
        name == currBible.name
    }
}
