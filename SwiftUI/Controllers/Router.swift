//
//  RouterView.swift
//  SwiftUI
//
//  Created by Vladimir Rybant on 15.01.2024.
//  Copyright © 2024 Vladimir Rybant. All rights reserved.
//

// isPresented https://medium.com/@fsamuelsmartins/how-to-use-the-swiftuis-navigationstack-79f32ada7c69

import SwiftUI
import Observation

enum BibleRoute: Hashable {
    case books
    case chapters(String)
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
