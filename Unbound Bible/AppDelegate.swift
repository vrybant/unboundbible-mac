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
    @IBOutlet weak var recentMenu: NSMenu!
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        appDelegate = self
        UserDefaults.standard.set(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints​")
        UserDefaults.standard.synchronize()
//      copySpecial.isEnabled = false
        readDefaults()
        initialization()
        readPrivates()
        createRecentMenu()
//      split_View.splitView.setPosition(CGFloat(500), ofDividerAt: 0)
    }
    
    @IBAction func menuItemSelected(_ sender : NSMenuItem) {
        print("item-" + sender.title)
    }
    
    @IBAction func clearRecentMenu(_ sender: Any?) {
        print("clearRecentMenu")
    }
    
    func createRecentMenu() {
        let subMenu = NSMenu()
        let newMenuItem = NSMenuItem()

        for line in recentList {
            subMenu.addItem(withTitle: line, action: #selector(menuItemSelected(_:)), keyEquivalent: "")
        }
        
        let clearMenuTitle = NSLocalizedString("Clear Menu", comment: "")
        subMenu.addItem(withTitle: clearMenuTitle, action: #selector(clearRecentMenu(_:)), keyEquivalent: "")
        
        newMenuItem.submenu = subMenu
        NSApplication.shared.menu?.setSubmenu(subMenu, for: recentMenuItem)
        recentMenu.addItem(newMenuItem)
    }
    
    func initialization() {
        if shelf.bibles.isEmpty { return }
        leftView.bibleMenuInit()
        mainView.updateStatus(shelf.bibles[current].info)
        leftView.makeBookList()
        goToVerse(activeVerse, select: (activeVerse.number > 1))
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
    
/**
procedure TMainForm.ReadIniFile;
  FBPageVisited := IniFile.ReadBool('Application', 'FBPage', False);
  Max := IniFile.ReadInteger('Reopen', 'Count', ReopenList.Count);
  for i := 0 to Max - 1 do ReopenList.Add(IniFile.ReadString('Reopen', 'File_' + IntToStr(i), ''));
**/
    
    func readDefaults() {
        activeVerse.book    = UserDefaults.standard.integer(forKey: "active_VerseBook")
        activeVerse.chapter = UserDefaults.standard.integer(forKey: "activeVerseChapter")
        activeVerse.number  = UserDefaults.standard.integer(forKey: "activeVerseNumber")
        activeVerse.count   = UserDefaults.standard.integer(forKey: "activeVerseCount")

        if let fontName  = UserDefaults.standard.string(forKey: "fontName") {
            let fontSize = UserDefaults.standard.float(forKey: "fontSize")
            defaultFont = NSFont(name: fontName, size: CGFloat(fontSize))!
        }
        
        if let file = UserDefaults.standard.string(forKey: "current") {
            shelf.setCurrent(file)
        }

        let value = UserDefaults.standard.integer(forKey: "copyOptions")
        copyOptions = CopyOptions(rawValue: value)
        
        if let list = UserDefaults.standard.string(forKey: "recentList") {
            recentList = list.components(separatedBy: ";")
        }
    }

    func saveDefaults() {
        UserDefaults.standard.set(shelf.bibles[current].fileName, forKey: "current")
        
        UserDefaults.standard.set(activeVerse.book,      forKey: "activeVerseBook")
        UserDefaults.standard.set(activeVerse.chapter,   forKey: "activeVerseChapter")
        UserDefaults.standard.set(activeVerse.number,    forKey: "activeVerseNumber")
        UserDefaults.standard.set(activeVerse.count,     forKey: "activeVerseCount")
        UserDefaults.standard.set(copyOptions.rawValue,  forKey: "copyOptions")
        UserDefaults.standard.set(defaultFont.fontName , forKey: "fontName")
        UserDefaults.standard.set(defaultFont.pointSize, forKey: "fontSize")
        
        let list = recentList.joined(separator: ";")
        UserDefaults.standard.set(list, forKey: "recentList")
  
        UserDefaults.standard.synchronize()
    }
    
    func readPrivates() {
        for item in shelf.bibles {
            item.compare = UserDefaults.standard.bool(forKey: item.fileName)
        }
        UserDefaults.standard.synchronize()
    }
    
    func savePrivates() {
        for item in shelf.bibles {
            UserDefaults.standard.set(item.compare, forKey: item.fileName)
        }
        UserDefaults.standard.synchronize()
    }

}

