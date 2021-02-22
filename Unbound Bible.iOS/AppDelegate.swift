//
//  AppDelegate.swift
//  Unbound Bible.iOS
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initialization()
        return true
    }

    func initialization() {
        readDefaults()
        copyDefaultsFiles()
        if shelf.isEmpty { return }
        shelf.setCurrent(defaultCurrent!)
        
//      leftView.bibleMenuInit()
//      mainView.updateStatus(bible!.info)
//      leftView.makeBookList()
//      goToVerse(currVerse, select: (currVerse.number > 1))
        
        readPrivates()
        
//      createRecentMenu()
//      localization()
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

