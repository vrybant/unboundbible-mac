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
    
    @State private var router = Router()
    
    init() {
        initialization()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(router)
        }
    }
}
