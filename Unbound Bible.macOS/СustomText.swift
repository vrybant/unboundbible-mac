//
//  CustomText.swift
//  Unbound Bible 
//
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import Cocoa

enum Foreground {
    case text, link, footnote, strong
}

class CustomTextView: NSTextView {
    
    var modified = false
    var isDark = false
    var hyperlink = ""
    var foreground = Foreground.text
    
    override func draw(_ dirtyRect: NSRect) {
        if darkAppearance != isDark { updateColors() }
        isDark = darkAppearance
        super.draw(dirtyRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//      self.isContinuousSpellCheckingEnabled = false
    }
    
    private var id : String {
        return identifier?.rawValue ?? ""
    }

    var selectedString: String {
        let range = selectedRange
        let string = attributedString().attributedSubstring(from: range).string
        return string
    }
    
    private func getForegroundColor(_ x: Int) -> NSColor {
        if x < self.attributedString().length {
            let range = NSRange(location: x, length: 1)
            let attrChar = self.attributedString().attributedSubstring(from: range)
            if let color = attrChar.attribute(.foregroundColor, at: 0, effectiveRange: nil) {
                return color as! NSColor
            }
        }
        return .black
    }
    
    func getForeground(_ x: Int) -> Foreground {
        switch getForegroundColor(x) {
        case .systemNavy  : return .link
        case .systemBrown : return .strong
        case .systemTeal  : return .footnote
        default           : return .text
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
    
    func setHyperlink() {
        let navy = getForegroundColor(selectedRange.location) == NSColor.systemNavy
        let color = navy ? NSColor.black : NSColor.systemNavy
        self.textStorage?.addAttribute(.foregroundColor, value: color, range: selectedRange)
    }
    
    func strike() {
        let style = striked(selectedRange.location) ? 0 : 1
        self.textStorage?.addAttribute(.strikethroughStyle, value: style, range: selectedRange)
    }

    private func getLink() -> String {
        if selectedRange.length > 0 { return "" }
        if foreground == .text { return "" }
        
        let length = attributedString().length
        var x1 = selectedRange.location
        
        while getForeground(x1) == foreground, x1 < length { x1 += 1 }; var x2 = x1 - 1;
        while getForeground(x2) == foreground, x2 > 0      { x2 -= 1 };
        
        if x2 > 0 { x2 += 1 }
        
        let range = NSRange(location: x2, length: x1-x2)
        let string = self.attributedString().attributedSubstring(from: range).string
        
        return string.trimmed
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)

        if selectedRange.length != 0 { return }

        foreground = getForeground(selectedRange.location)
        hyperlink = getLink()
        
        if foreground == .link {
            if let verse = currBible!.stringToVerse(link: hyperlink) {
                goToVerse(verse, select: true)
            }
        }

        if id == "Notes" { return }
        
        if foreground == .strong {
            if let string = get_Strong(number: hyperlink) {
                let attrString = parse(string, small: true).mutable()
                mainView.showPopover(self)
                popoverView!.textView.textStorage?.setAttributedString(attrString)
            }
        }
    }
    
    override func didChangeText() {
        super.didChangeText()
        modified = true
    }
    
    override func printView(_ sender: Any?) {
        if darkAppearance {
            let view = NSTextView.init(frame: self.frame)
            let text = self.attributedString()
            view.textStorage?.setAttributedString(text)
            view.printView(view)
        } else {
            super.printView(self)
        }
    }
    
    func clean() {
        self.textStorage?.mutableString.setString("")
        self.modified = false
    }

    func updateColors() {
        let text = self.attributedString().mutable().withSystemColors()
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
