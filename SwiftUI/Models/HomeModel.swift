//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

@Observable
class HomeModel {
    static let shared = HomeModel()
    var route = HomeRoute.bible
}
