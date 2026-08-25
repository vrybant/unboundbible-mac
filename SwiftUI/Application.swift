//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

// https://developer.apple.com/support/app-store/
// 86% of all devices use iOS 26

import Foundation
import SwiftUI

func initialization() {
    if tools.bibles.isEmpty { return } // tools.init
}

@main
struct Application: App {
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        initialization()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
        .onChange(of: scenePhase) { newPhase, _ in
            if newPhase == .inactive || newPhase == .background {
                saveDefaults()
            }
        }
}
}
