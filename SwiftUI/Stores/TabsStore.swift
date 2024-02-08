//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation
import Combine

class TabsStore: ObservableObject {
    static let shared = TabsStore()
    
    @Published var selection = TabsRoute.bible
    
    private init() {}
}
