//
//  NotesText.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa
import Foundation

class NotesTextView: СommonTextView {

    @IBAction func hyperlink(_ sender: NSMenuItem) {
        setHyperlink()
    }
    
    @IBAction func strikethrough(_ sender: NSMenuItem) {
        setStrikethrough()
    }
    
}
