//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

@Observable class HomeStore {
    static let shared = HomeStore()
    
    var selection = HomeRoute.bible
    
    private init() {}
}
