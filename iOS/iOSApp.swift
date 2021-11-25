//
//  iOSApp.swift
//  iOS
//
//  Created by Vladimir Rybant on 22/11/2021.
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import SwiftUI

@main
struct iOSApp: App {
    init() {
        readDefaults()
        copyDefaultsFiles()
        if tools.bibles.isEmpty { return }
        tools.setCurrBible(defaultCurrBible!)
        
    //      leftView.bibleMenuInit()
    //      mainView.updateStatus(bible!.info)
    //      leftView.makeBookList()
    //      goToVerse(currVerse, select: (currVerse.number > 1))
        
        readPrivates()
        
    //      createRecentMenu()
    //      localization()
        print("initializated")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
