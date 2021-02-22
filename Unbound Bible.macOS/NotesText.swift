//
//  NotesText.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Cocoa
import Foundation

class NotesTextView: СommonTextView {

    @IBAction func fontPanel(_ sender: NSMenuItem) {
        NSFontManager.shared.orderFrontFontPanel(self)
    }

    @IBAction func colorPanel(_ sender: NSMenuItem) {
            NSColorPanel.shared.orderFront(self)
    }
    
    @IBAction func bold(_ sender: NSMenuItem) {
        let fontManager = NSFontManager.shared
        let fontName = fontManager.selectedFont?.fontName ?? "None"
        if fontName.contains("Bold") {
            fontManager.removeFontTrait(sender)
        } else {
            fontManager.addFontTrait(sender)
        }
    }

    @IBAction func italic(_ sender: NSMenuItem) {
        let fontManager = NSFontManager.shared
        let fontName = fontManager.selectedFont?.fontName ?? "None"
        if fontName.contains("Italic") || fontName.contains("Oblique") {
            fontManager.removeFontTrait(sender)
        } else {
            fontManager.addFontTrait(sender)
        }
    }

    @IBAction func underlineAction(_ sender: NSMenuItem) {
        underline(sender)
    }
    
    @IBAction func strikethrough(_ sender: NSMenuItem) {
        strike()
    }
    
    @IBAction func hyperlink(_ sender: NSMenuItem) {
        setHyperlink()
    }
    
    @IBAction func bigger(_ sender: NSMenuItem) {
        NSFontManager.shared.modifyFont(sender)
    }
    
    @IBAction func smaller(_ sender: NSMenuItem) {
        NSFontManager.shared.modifyFont(sender)
    }

}
