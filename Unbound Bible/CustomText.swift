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
    
    func colored(x: Int) -> Bool {
        if x < self.attributedString().length {
            let range = NSRange(location: x, length: 1)
            let attrChar = self.attributedString().attributedSubstring(from: range)
            if let color = attrChar.attribute(NSAttributedStringKey.foregroundColor, at: 0, effectiveRange: nil) {
                return color as! NSColor == navyColor
            }
        }
        return false
    }
    
    func getSelection() -> String {
        let range = self.selectedRange
        let attrStr = self.attributedString().attributedSubstring(from: range)
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

    /*
    func loadFromFile(url: URL) throws {
        if let attributedString: NSAttributedString = try? NSAttributedString(url: url, options: [NSAttributedString.DocumentAttributeKey.documentType:NSAttributedString.DocumentType.rtf], documentAttributes: nil) {
            self.textStorage?.setAttributedString(attributedString)
            self.modified = false
        } else {
            throw Errors.someError
        }
    }
    */
    
    func saveToFile(url: URL) throws {
        let text = self.attributedString()
        let range = NSRange(0..<text.length)
        
        if let textSave = try? text.fileWrapper(from: range, documentAttributes: [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.rtf]) {
            do {
                try textSave.write(to: url, options: FileWrapper.WritingOptions.atomic, originalContentsURL: nil)
                self.modified = false
            } catch {
                throw Errors.someError
            }
        }
    }
    
}
