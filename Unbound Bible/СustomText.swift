//
//  CustomText.swift
//  Unbound Bible OSX
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

class CustomTextView: NSTextView {
    
    var modified = false
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//      self.isContinuousSpellCheckingEnabled = false
    }
    
    func colored(_ x: Int) -> Bool {
        if x < self.attributedString().length {
            let range = NSRange(location: x, length: 1)
            let attrChar = self.attributedString().attributedSubstring(from: range)
            if let color = attrChar.attribute(NSAttributedStringKey.foregroundColor, at: 0, effectiveRange: nil) {
                return color as! NSColor == navyColor
            }
        }
        return false
    }
    
    func setStrikethrough() {
        self.textStorage?.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: selectedRange)
    }
    
    func setHyperlink() {
        let color = colored(selectedRange.location) ? NSColor.black : navyColor
        self.textStorage?.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: selectedRange)
    }
    
    func getSelection() -> String {
        let attrStr = self.attributedString().attributedSubstring(from: selectedRange)
        return attrStr.string
    }
    
    func selected() -> Bool {
        return self.selectedRange().length > 0
    }
        
    override func didChangeText() {
        super.didChangeText()
        modified = true
    }
    
    func clean() {
        self.textStorage?.mutableString.setString("")
        self.modified = false
    }

    func loadFromFile(url: URL) throws {
        let options : [NSAttributedString.DocumentReadingOptionKey : Any] = [ .documentType : NSAttributedString.DocumentType.rtf]
        if let attributedString: NSAttributedString = try? NSAttributedString(url: url, options: options, documentAttributes: nil) {
            self.textStorage?.setAttributedString(attributedString)
            self.modified = false
        } else {
            throw Errors.someError
        }
    }
    
    func saveToFile(url: URL) throws {
        let text = self.attributedString()
        let range = NSRange(0..<text.length)
        
        let attributes = [NSAttributedString.DocumentAttributeKey.documentType : NSAttributedString.DocumentType.rtf]
        if let wrapper = try? text.fileWrapper(from: range, documentAttributes: attributes) {
            do {
                try wrapper.write(to: url, options: FileWrapper.WritingOptions.atomic, originalContentsURL: nil)
                self.modified = false
            } catch {
                throw Errors.someError
            }
        }
    }
    
}
