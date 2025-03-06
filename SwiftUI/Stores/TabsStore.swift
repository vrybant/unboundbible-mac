//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

@Observable class TabsStore {
    static let shared = TabsStore()
    
    var selection = TabsRoute.bible
    
    private init() {}
}
