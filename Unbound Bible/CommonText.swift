//
//  SuperText.swift
//  Unbound Bible OSX
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation
import Cocoa

class СommonTextView: CustomTextView {
    
    func getLink() -> String? {
        if selectedRange.length > 0 { return nil }
        if !colored(selectedRange.location) { return nil }
        
        let length = attributedString().length
        var x1 = selectedRange.location
        
        while colored(x1) && (x1 < length) { x1 += 1 }; var x2 = x1 - 1;
        while colored(x2) && (x2 > 0     ) { x2 -= 1 };
        
        if x2 > 0 { x2 += 1 }
        
        let range = NSRange(location: x2, length: x1-x2)
        let string = self.attributedString().attributedSubstring(from: range).string
//      self.setSelectedRange(range)
        return string
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        guard let link = getLink() else { return }
        
        if let verse = bible.stringToVerse(link: link) {
            goToVerse(verse, select: true)
        }
    }
    
    @IBAction func printDocument(_ sender: NSMenuItem) {
        printView(self)
    }
    
}

