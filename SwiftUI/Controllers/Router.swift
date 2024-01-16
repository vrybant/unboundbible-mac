//
//  RouterView.swift
//  SwiftUI
//
//  Created by Vladimir Rybant on 15.01.2024.
//  Copyright © 2024 Vladimir Rybant. All rights reserved.
//

import SwiftUI
import Observation

enum BibleRoute {
    case home
    case detail
}

enum SearchRoute: Hashable {
    case home
    case detail(String)
}

@Observable
class Router {
    var bibleRoutes: [BibleRoute] = []
    var searchRoutes: [SearchRoute] = []
}
