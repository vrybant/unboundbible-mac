//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

// https://developer.apple.com/support/app-store/
// 82% of all devices use iOS 18

import Foundation
import SwiftUI

func initialization() {
    readDefaults()
    if tools.bibles.isEmpty { return } // tools.init
}

@main
struct Application: App {
    
    init() {
        initialization()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
    }
}
