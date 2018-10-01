//
//  CustomText.swift
//  Unbound Bible OSX
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

enum Foreground {
    case none, link, footnote, strong
}

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
    
    func selectedColor(_ x: Int) -> NSColor {
        if x < self.attributedString().length {
            let range = NSRange(location: x, length: 1)
            let attrChar = self.attributedString().attributedSubstring(from: range)
            if let color = attrChar.attribute(.foregroundColor, at: 0, effectiveRange: nil) {
                return color as! NSColor
            }
        }
        return NSColor.black
    }
    
    func navy(_ x: Int) -> Bool {
        return selectedColor(x) == navyColor
    }
    
    func selectedForeground(_ x: Int) -> Foreground {
        switch selectedColor(x) {
        case navyColor     : return .link
        case NSColor.brown : return .strong
        case NSColor.gray  : return .footnote
        default            : return .none
        }
    }
    
    func striked(_ x: Int) -> Bool {
        if x < self.attributedString().length {
            let range = NSRange(location: x, length: 1)
            let attrChar = self.attributedString().attributedSubstring(from: range)
            if let style = attrChar.attribute(.strikethroughStyle, at: 0, effectiveRange: nil) {
                return style as! Int == 1
            }
        }
        return false
    }
    
    func hyperlink() {
        let color = navy(selectedRange.location) ? NSColor.black : navyColor
        self.textStorage?.addAttribute(.foregroundColor, value: color, range: selectedRange)
    }
    
    func strike() {
        let style = striked(selectedRange.location) ? 0 : 1
        self.textStorage?.addAttribute(.strikethroughStyle, value: style, range: selectedRange)
    }
    
    func getSelection() -> String {
        let attrStr = self.attributedString().attributedSubstring(from: selectedRange)
        return attrStr.string
    }
    
    func getLink() -> String? {
        if selectedRange.length > 0 { return nil }
        let foreground = selectedForeground(selectedRange.location)
        if foreground == .none { return nil }
        
        let length = attributedString().length
        var x1 = selectedRange.location
        
        while selectedForeground(x1) == foreground, x1 < length { x1 += 1 }; var x2 = x1 - 1;
        while selectedForeground(x2) == foreground, x2 > 0      { x2 -= 1 };
        
        if x2 > 0 { x2 += 1 }
        
        let range = NSRange(location: x2, length: x1-x2)
        let string = self.attributedString().attributedSubstring(from: range).string
//      self.setSelectedRange(range)
        
        print(foreground, string)
        return string
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        let foreground = selectedForeground(selectedRange.location)
        guard let link = getLink() else { return }
        
        if foreground == .link {
            if let verse = bible!.stringToVerse(link: link) {
                goToVerse(verse, select: true)
            }
        }
        
        if foreground == .strong {
            //
        }
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
