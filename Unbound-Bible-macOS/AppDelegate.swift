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
    
    @IBOutlet weak var copySpecial: NSMenuItem!
    @IBOutlet weak var saveMenuItem: NSMenuItem!
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        appDelegate = self
        UserDefaults.standard.set(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints​")
        UserDefaults.standard.synchronize()
//      copySpecial.isEnabled = false
        readDefaults()
        initialization()
        readPrivates()
//      split_View.splitView.setPosition(CGFloat(500), ofDividerAt: 0)
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
    
    @IBAction func copySpecialAction(_ sender: NSMenuItem) {
        copyVerses(options: copyOptions).copyToPasteboard()
    }
    
/**
procedure TMainForm.ReadIniFile;
  CurrFont.Name := IniFile.ReadString('Application', 'FontName', CurrFont.Name);
  CurrFont.Size := IniFile.ReadInteger('Application', 'FontSize', CurrFont.Size);
  PanelLeft.Width := IniFile.ReadInteger('Application', 'Splitter', 270);
  FaceLang := IniFile.ReadString('Application', 'Interface', GetDefaultLanguage);
  ShortLink := IniFile.ReadBool('Application', 'ShortLink', True);
  FBPageVisited := IniFile.ReadBool('Application', 'FBPage', False);
  Max := IniFile.ReadInteger('Reopen', 'Count', ReopenList.Count);
  for i := 0 to Max - 1 do ReopenList.Add(IniFile.ReadString('Reopen', 'File_' + IntToStr(i), ''));
**/
    
    func readDefaults() {
        activeVerse.book    = UserDefaults.standard.integer(forKey: "activeVerseBook")
        activeVerse.chapter = UserDefaults.standard.integer(forKey: "activeVerseChapter")
        activeVerse.number  = UserDefaults.standard.integer(forKey: "activeVerseNumber")
        activeVerse.count   = UserDefaults.standard.integer(forKey: "activeVerseCount")
        
        if let file = UserDefaults.standard.string(forKey: "current") {
            shelf.setCurrent(file)
        }
        
        let value = UserDefaults.standard.integer(forKey: "copyOptions")
        copyOptions = CopyOptions(rawValue: value)
    }
    
    func saveDefaults() {
        UserDefaults.standard.set(shelf.bibles[current].fileName, forKey: "current")
        
        UserDefaults.standard.set(activeVerse.book,    forKey: "activeVerseBook")
        UserDefaults.standard.set(activeVerse.chapter, forKey: "activeVerseChapter")
        UserDefaults.standard.set(activeVerse.number,  forKey: "activeVerseNumber")
        UserDefaults.standard.set(activeVerse.count,   forKey: "activeVerseCount")

        UserDefaults.standard.set(copyOptions.rawValue, forKey: "copyOptions")
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

