//
//  iOSApp.swift
//  Unbound Bible
//
//  Copyright © Vladimir Rybant. All rights reserved.
//

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
