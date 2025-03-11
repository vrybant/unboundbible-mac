//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation

@Observable class ShelfStore {
    static let shared = ShelfStore()
    
    var content = tools.get_Shelf().identifiable

    private init() {}

    func update(bible: String) {
        tools.setCurrBible(bible)
        content = tools.get_Shelf().identifiable
        BibleStore.shared.refresh()
    }
    
    func isCurrent(name: String) -> Bool {
        name == currBible.name
    }
}
