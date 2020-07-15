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
    
    override func update() {
        self.autoenablesItems = false
 
        let selectedString = rigthView.bibleTextView.selectedString.trimmed
        let enabled = selectedString.length > 1
        
        searchMenuItem.isEnabled = enabled
        lookupMenuItem.isEnabled = enabled
        copyMenuItem.isEnabled   = !selectedString.isEmpty
    }

}
