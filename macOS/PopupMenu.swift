//
//  PopupMenu.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Cocoa

class PopupMenu: NSMenu {
 
    @IBOutlet weak var searchMenuItem: NSMenuItem!
    @IBOutlet weak var lookupMenuItem: NSMenuItem!
    @IBOutlet weak var cutMenuItem: NSMenuItem!
    @IBOutlet weak var copyMenuItem: NSMenuItem!
    @IBOutlet weak var copyVersesMenuItem: NSMenuItem!
    @IBOutlet weak var copyAsMenuItem: NSMenuItem!
    @IBOutlet weak var pasteMenuItem: NSMenuItem!
    @IBOutlet weak var separatorMenuItem: NSMenuItem!
        
    override func update() {
        autoenablesItems = false
        allowsContextMenuPlugIns = false
        
        let selection = rigthView.selectedString.trimmed
        let tab = rigthView.tabView.selectedTab!
        
        let b = tab == "bible"
        let n = tab == "notes"
        let s = selection.count > (b ? 1 : 0)
        let m = selection.contains("\n") // multiline
        
        searchMenuItem.isHidden = !s || m
        lookupMenuItem.isHidden = !s || m
        
        cutMenuItem.isHidden = !n
        cutMenuItem.isEnabled = s
        copyMenuItem.isEnabled = s
        pasteMenuItem.isHidden = !n

        copyVersesMenuItem.isEnabled = b
        copyVersesMenuItem.isHidden = n
        copyAsMenuItem.isEnabled = b
        copyAsMenuItem.isHidden = n
        
        separatorMenuItem.isHidden = !s || m
        
        if !searchMenuItem.isHidden {
            searchMenuItem.title = LocalizedString("Search for %").replace("%", with: selection.quoted)
            lookupMenuItem.title = LocalizedString("Look Up %")   .replace("%", with: selection.quoted)
        }

    }

}
