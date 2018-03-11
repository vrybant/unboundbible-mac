//
//  AppDelegate.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation
import Cocoa

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
        createRecentMenu()
        localization()
    }
    
    func initialization() {
        createDirectories()
        readDefaults()
        if shelf.isEmpty { return }
        leftView.bibleMenuInit()
        mainView.updateStatus(bible!.info)
        leftView.makeBookList()
        goToVerse(activeVerse, select: (activeVerse.number > 1))
        readPrivates()
    }
    
    func localization() {
        if languageCode() == "uk" {
            defaultBaseline.title = "Стандартна"
            defaultDirection.title = "Стандартний"
        }
    }
    
    @IBAction func menuItemSelected(_ sender : NSMenuItem) {
        let tag = sender.tag
        if 0..<recentList.count ~= tag {
            let path = recentList[tag]
            let url = URL(fileURLWithPath: path)
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
                item.title = URL(fileURLWithPath: recentList[i]).lastPathComponent
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
        if mainView.closeDocument() {
            return NSApplication.TerminateReply.terminateNow
        } else {
            return NSApplication.TerminateReply.terminateCancel
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        saveDefaults()
        savePrivates()
    }
    
    func readDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints​")
        defaults.synchronize()

        activeVerse.book    = defaults.integer(forKey: "active_VerseBook")
        activeVerse.chapter = defaults.integer(forKey: "activeVerseChapter")
        activeVerse.number  = defaults.integer(forKey: "activeVerseNumber")
        activeVerse.count   = defaults.integer(forKey: "activeVerseCount")
        recentList = defaults.stringArray(forKey: "recentList") ?? [String]()
        
        if let fontName  = defaults.string(forKey: "fontName") {
            let fontSize = defaults.float(forKey: "fontSize")
            defaultFont = NSFont(name: fontName, size: CGFloat(fontSize))!
        }
        
        if let file = defaults.string(forKey: "current") {
            shelf.setCurrent(file)
        } else {
            switch languageCode() {
            case "ru" : shelf.setCurrent("rstw.unbound")
            case "uk" : shelf.setCurrent("ubio.unbound")
            default : shelf.setCurrent("kjv.unbound")
            }
        }
        
        let value = defaults.integer(forKey: "copyOptions")
        copyOptions = CopyOptions(rawValue: value)
    }
    
    func saveDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(bible!.fileName,       forKey: "current")
        defaults.set(activeVerse.book,      forKey: "activeVerseBook")
        defaults.set(activeVerse.chapter,   forKey: "activeVerseChapter")
        defaults.set(activeVerse.number,    forKey: "activeVerseNumber")
        defaults.set(activeVerse.count,     forKey: "activeVerseCount")
        defaults.set(copyOptions.rawValue,  forKey: "copyOptions")
        defaults.set(defaultFont.fontName , forKey: "fontName")
        defaults.set(defaultFont.pointSize, forKey: "fontSize")
        defaults.set(recentList,            forKey: "recentList")
        defaults.synchronize()
//        let domain = Bundle.main.bundleIdentifier!
//        defaults.removePersistentDomain(forName: domain)
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

