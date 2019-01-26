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
    
    var defaultCurrent : String?
    
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
        mainView.updateStatus(bible!.info)
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
    
    func readDefaults() {
        let defaults = UserDefaults.standard
//      let domain = Bundle.main.bundleIdentifier!
//      defaults.removePersistentDomain(forName: domain) // debug
        defaults.set(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints​")
        defaults.synchronize()

        applicationUpdate = defaults.string(forKey: "applicationVersion") != applicationVersion
        defaultCurrent = defaults.string(forKey: "current") ?? defaultBible

        activeVerse.book    = defaults.integer(forKey: "verseBook")
        activeVerse.chapter = defaults.integer(forKey: "verseChapter")
        activeVerse.number  = defaults.integer(forKey: "verseNumber")
        activeVerse.count   = defaults.integer(forKey: "verseCount")
        
        if let fontName = defaults.string(forKey: "fontName") {
            let fontSize = defaults.cgfloat(forKey: "fontSize")
            defaultFont = NSFont(name: fontName, size: fontSize)!
        }
        
        let value = defaults.integer(forKey: "copyOptions")
        copyOptions = CopyOptions(rawValue: value)

        if let bookmarks = defaults.object(forKey: "bookmarks") as? [Data] {
            recentList.append(bookmarks: bookmarks)
        }
    }
    
    func saveDefaults() {
        if shelf.isEmpty { return }
        let defaults = UserDefaults.standard
        defaults.set(applicationVersion,    forKey: "applicationVersion")
        defaults.set(bible!.fileName,       forKey: "current")
        defaults.set(activeVerse.book,      forKey: "verseBook")
        defaults.set(activeVerse.chapter,   forKey: "verseChapter")
        defaults.set(activeVerse.number,    forKey: "verseNumber")
        defaults.set(activeVerse.count,     forKey: "verseCount")
        defaults.set(copyOptions.rawValue,  forKey: "copyOptions")
        defaults.set(defaultFont.fontName , forKey: "fontName")
        defaults.set(defaultFont.pointSize, forKey: "fontSize")
        defaults.set(recentList.bookmarks,  forKey: "bookmarks")
        defaults.synchronize()
    }
    
    func readPrivates() {
        for item in shelf.bibles {
            item.compare = !UserDefaults.standard.bool(forKey: item.fileName)
        }
        UserDefaults.standard.synchronize()
    }
    
    func savePrivates() {
        for item in shelf.bibles {
            UserDefaults.standard.set(!item.compare, forKey: item.fileName)
        }
        UserDefaults.standard.synchronize()
    }
    
}

