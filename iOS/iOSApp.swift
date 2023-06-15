//
//  iOSApp.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation
import SwiftUI

func initialization() {
    readDefaults()
    if tools.bibles.isEmpty { return } // tools.init
    print(tools.bibles.getDefaultBible)
}

@main
struct iOSApp: App {
    @StateObject var userBuy = UserBuy()

    init() {
        initialization()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(userBuy)
        }
    }
}
