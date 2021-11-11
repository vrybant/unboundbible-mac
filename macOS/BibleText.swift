//
//  BibleText.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Cocoa

class BibleTextView: CustomTextView {
    
    private func colored(_ x: Int) -> Bool {
        return getForeground(x) == .link
    }

    func selectParagraph(number: Int) {
        let length = self.attributedString().length
        
        var x1 = 0
        while x1 < length {
            while !colored(x1), x1 < length { x1 += 1 }; var x2 = x1;
            while  colored(x2), x2 < length { x2 += 1 }
            
            let range = NSRange(location: x1, length: x2-x1)
            let str = self.attributedString().attributedSubstring(from: range).string
            
            if str == String(number) {
                let range = NSRange(location: x1 - 1, length: 1)
                self.setSelectedRange(range)
                self.scrollRangeToVisible(range)
                break
            }
            x1 = x2
        }
    }
    
    
    private func paragraphFromSelection(beginning: Bool) -> Int {
        var location = self.selectedRange.location
        if beginning { location += 1 }
        if !beginning { location += self.selectedRange.length }
        
        if location < 2 { return 1 }
        
        var x1 = location
        while !colored(x1) && (x1 > 0) { x1 -= 1 }
        while  colored(x1) && (x1 > 0) { x1 -= 1 }
        x1 += 1
        var x2 = x1
        while colored(x2) { x2 += 1 }
        
        let range = NSRange(location: x1, length: x2 - x1)
        let num = self.attributedString().attributedSubstring(from: range).string
        
        if self.selectedRange.length == 0 {
            self.setSelectedRange(NSRange(location: x1-1, length: 1))
        }
        return Int(num) ?? 1
    }
    
    private func getParagraphNumber(saveRange: Bool = false) {
        if selectedRange.length == 0 {
            let range = selectedRange()
            currVerse.number = paragraphFromSelection(beginning: true)
            currVerse.count = 1
            if saveRange { setSelectedRange(range) }
        }
    }
    
    private func getParagraphRange() {
        if self.selectedRange.length > 1 {
            currVerse.number = paragraphFromSelection(beginning: true )
            currVerse.count  = paragraphFromSelection(beginning: false) - currVerse.number + 1
        }
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        return self.menu
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        getParagraphNumber(saveRange: true)
        
        if selectedRange.length != 0 { return }
        
        if foreground == .footnote {
            let f = tools.get_Footnote(marker: hyperlink)
            let attrs = parse(f, small: true).mutable()
            mainView.showPopover(self)
            popoverView!.textView.textStorage?.setAttributedString(attrs)
        }

        getParagraphNumber()
    }
    
    override func selectionRange(forProposedRange proposedCharRange: NSRange, granularity: NSSelectionGranularity) -> NSRange {
        getParagraphRange()
        return super.selectionRange(forProposedRange: proposedCharRange, granularity: granularity)
    }
    
    @IBAction func copyVersesAction(_ sender: NSMenuItem) {
        tools.get_Verses(options: copyOptions).copyToPasteboard()
    }
    
    @IBAction func copyDialogAction(_ sender: NSMenuItem) {
        mainView.presentAsModalWindow(copyView)
    }
    
}
