//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation
import Observation

@Observable
class ShelfStore {
    static let shared = ShelfStore()
    
    var content = tools.get_Shelf()

    private init() {}

    func update(bible: String) {
        tools.setCurrBible(bible)
        content = tools.get_Shelf()
        MainStore.shared.update()
    }
}
