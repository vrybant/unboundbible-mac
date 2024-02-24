//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation
import Combine

class ShelfStore: ObservableObject {
    static let shared = ShelfStore()
    
    @Published var content = tools.get_Shelf()

    private init() {}

    func update(bible: String) {
        tools.setCurrBible(bible)
        content = tools.get_Shelf()
        BibleStore.shared.refresh()
    }
    
    func isCurrent(name: String) -> Bool {
        name == currBible.name
    }
}
