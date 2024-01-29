//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

// https://developer.apple.com/support/app-store/
// 81% of all devices use iOS 16

import Foundation
import SwiftUI

func initialization() {
    readDefaults()
    if tools.bibles.isEmpty { return } // tools.init
}

@main
struct iOSApp: App {
    
    init() {
        initialization()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
