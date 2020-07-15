//
//  AppDelegate.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

var appDelegate = AppDelegate()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var saveMenuItem: NSMenuItem!
    @IBOutlet weak var recentMenuItem: NSMenuItem!
    @IBOutlet weak var defaultBaseline: NSMenuItem!
    @IBOutlet weak var defaultDirection: NSMenuItem!
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        appDelegate = self
        initialization()
    }
    
    func initialization() {
        readDefaults()
        copyDefaultsFiles()
        if shelf.isEmpty { return }
        shelf.setCurrent(defaultCurrent!)
        leftView.bibleMenuInit()
        mainView.updateStatus(bible!.fileName + " | " + bible!.info)
        leftView.makeBookList()
        goToVerse(activeVerse, select: (activeVerse.number > 1))
        readPrivates()
        createRecentMenu()
        localization()
    }
    
    func localization() {
        if languageCode == "uk" {
            defaultBaseline.title = "Стандартна"
            defaultDirection.title = "Стандартний"
        }
    }
    
    @IBAction func menuItemSelected(_ sender : NSMenuItem) {
        let tag = sender.tag
        if 0..<recentList.count ~= tag {
            let url = recentList[tag]
            if mainView.closeDocument() {
                mainView.openDocument(url: url)
            }
        }
    }
    
    @IBAction func clearRecentMenu(_ sender: Any?) {
        recentList = []
        createRecentMenu()
    }
    
    @IBAction func cmdSearch(_ sender: Any?) {
        let text = rigthView.bibleTextView.selectedString.trimmed
        if text.isEmpty { return }
        winController.searchField.stringValue = text
        rigthView.loadSearch(text: text)
    }
    
    @IBAction func cmdCompare(_ sender: Any?) {
        selectTab("compare")
    }
    
    @IBAction func cmdXref(_ sender: Any?) {
        selectTab("xref")
    }
    
    @IBAction func cmdCommentary(_ sender: Any?) {
        selectTab("commentary")
    }
    
    @IBAction func cmdLookUp(_ sender: Any?) {
        let text = rigthView.bibleTextView.selectedString.trimmed
        if text.isEmpty { return }
        winController.searchField.stringValue = text
        rigthView.loadDictionary(key: text)
    }
    
    @IBAction func cmdDictionary(_ sender: Any?) {
        selectTab("dictionary")
    }
    
    func createRecentMenu() {
        let submenu = NSMenu()
        
        if !recentList.isEmpty {
            for i in 0...recentList.count-1 {
                let item = NSMenuItem()
                item.title = recentList[i].lastPathComponent
                item.action = #selector(menuItemSelected(_:))
                item.keyEquivalent = ""
                item.tag = i
                submenu.addItem(item)
            }
        }
        
        submenu.addItem(NSMenuItem.separator())
        let title = NSLocalizedString("Clear Menu", comment: "")
        let action =  recentList.isEmpty ? nil : #selector(clearRecentMenu(_:))
        submenu.addItem(withTitle: title, action: action, keyEquivalent: "")
        NSApplication.shared.menu!.setSubmenu(submenu, for: recentMenuItem)
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        return mainView.closeDocument() ? .terminateNow : .terminateCancel
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        saveDefaults()
        savePrivates()
    }
        
}

