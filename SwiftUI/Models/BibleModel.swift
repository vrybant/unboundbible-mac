//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

@Observable
class BibleModel {
    static let shared = BibleModel()

    var router: [BibleRoute] = []

    private init() {}
}
