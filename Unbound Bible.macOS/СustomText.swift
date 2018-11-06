//
//  CustomText.swift
//  Unbound Bible OSX
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

enum Foreground {
    case text, link, footnote, strong
}

class CustomTextView: NSTextView {
    
    var modified = false
    var isDark = false

    override func draw(_ dirtyRect: NSRect) {
        if darkAppearance != isDark { updateColors() }
        isDark = darkAppearance
        super.draw(dirtyRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//      self.isContinuousSpellCheckingEnabled = false
    }
    
    func foregroundColor(_ x: Int) -> NSColor {
        if x < self.attributedString().length {
            let range = NSRange(location: x, length: 1)
            let attrChar = self.attributedString().attributedSubstring(from: range)
            if let color = attrChar.attribute(.foregroundColor, at: 0, effectiveRange: nil) {
                return color as! NSColor
            }
        }
        return NSColor.black
    }
    
    func foreground(_ x: Int) -> Foreground {
        switch foregroundColor(x) {
        case NSColor.systemNavy  : return .link
        case NSColor.systemBrown : return .strong
        case NSColor.systemGray  : return .footnote
        default            : return .text
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
        let navy = foregroundColor(selectedRange.location) == NSColor.systemNavy
        let color = navy ? NSColor.black : NSColor.systemNavy
        self.textStorage?.addAttribute(.foregroundColor, value: color, range: selectedRange)
    }
    
    func strike() {
        let style = striked(selectedRange.location) ? 0 : 1
        self.textStorage?.addAttribute(.strikethroughStyle, value: style, range: selectedRange)
    }
    
    func getLink() -> String? {
        if selectedRange.length > 0 { return nil }
        let fore = foreground(selectedRange.location)
        if fore == .none { return nil }
        
        let length = attributedString().length
        var x1 = selectedRange.location
        
        while foreground(x1) == fore, x1 < length { x1 += 1 }; var x2 = x1 - 1;
        while foreground(x2) == fore, x2 > 0      { x2 -= 1 };
        
        if x2 > 0 { x2 += 1 }
        
        let range = NSRange(location: x2, length: x1-x2)
        let string = self.attributedString().attributedSubstring(from: range).string
        
        return string
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        let fore = foreground(selectedRange.location)
        
        if fore != .text {
            if let link = getLink() {
                if let verse = bible!.stringToVerse(link: link) {
                    goToVerse(verse, select: true)
                }
            }
        }
        
        if fore == .strong {
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

    func updateColors() {
        let string = self.attributedString().mutable()
        let text = darkAppearance ? string.withSystemColors() : string.withNaturalColors()
        self.textStorage?.setAttributedString(text)
    }
    
    func loadFromFile(url: URL) throws {
        let options : [NSAttributedString.DocumentReadingOptionKey : Any] = [ .documentType : NSAttributedString.DocumentType.rtf]
        if let attributedString: NSAttributedString = try? NSAttributedString(url: url, options: options, documentAttributes: nil) {
            let text = darkAppearance ? attributedString.withSystemColors() : attributedString
            self.textStorage?.setAttributedString(text)
            self.modified = false
        } else {
            throw Errors.someError
        }
    }
    
    func saveToFile(url: URL) throws {
        let text = self.attributedString().withNaturalColors()
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
