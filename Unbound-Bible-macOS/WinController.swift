//
//  WinController.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

class WinController: NSWindowController, NSSearchFieldDelegate {
    
    @IBOutlet weak var searchField: NSSearchField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.titleVisibility = .hidden
        self.windowFrameAutosaveName = NSWindow.FrameAutosaveName(rawValue: "AutosaveWindows")
        
        //      self.window?.titlebarAppearsTransparent = true      // Bible Verse Desktop
        //      self.window?.styleMask.insert(.fullSizeContentView)
        //      self.window?.isMovableByWindowBackground = true
    }
    
    @IBAction func copyAction(_ sender: NSButton) {
        copyVerses(options: copyOptions).copyToPasteboard()
    }

    @IBAction func searchFieldAction(_ sender: NSSearchField) {
        let string = searchField.stringValue.trimmed()
        if string.length() > 2 {
            selectTab(at: .search)
            searchText(string: string)
        }
    }
    
}

