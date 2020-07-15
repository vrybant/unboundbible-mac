//
//  PopupMenu.swift
//  Unbound Bible
//
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import Cocoa

class PopupMenu: NSMenu {
 
    @IBOutlet weak var searchMenuItem: NSMenuItem!
    @IBOutlet weak var lookupMenuItem: NSMenuItem!
    @IBOutlet weak var copyMenuItem: NSMenuItem!
    @IBOutlet weak var separatorMenuItem: NSMenuItem!
    @IBOutlet weak var interlinearMenuItem: NSMenuItem!
    
    override func update() {
        self.autoenablesItems = false
 
        let selection = rigthView.bibleTextView.selectedString.trimmed
        let enabled = (selection.length > 1) && !selection.contains("\n")

        searchMenuItem.isHidden = !enabled
        lookupMenuItem.isHidden = !enabled
        separatorMenuItem.isHidden = !enabled
        copyMenuItem.isEnabled = !selection.isEmpty
        interlinearMenuItem.isHidden = selection.contains("\n")
        
        if enabled {
            searchMenuItem.title = LocalizedString("Search for %").replace("%", with: selection.quoted)
            lookupMenuItem.title = LocalizedString("Look Up %")   .replace("%", with: selection.quoted)
        }
    }

}
