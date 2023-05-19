//
//  iOSApp.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

@main
struct iOSApp: App {
    @StateObject var userBuy = UserBuy()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(userBuy)
        }
    }
}
