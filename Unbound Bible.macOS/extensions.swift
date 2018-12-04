//
//  extensions.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation
import Cocoa

extension Int32 {
    
    var int: Int {
        return Int(self)
    }
}

extension String {
    
    var length: Int {
        return self.count
    }
    
    var quoted: String {
        return "\"" + self + "\""
    }
    
    var int: Int {
        return Int(self) ?? 0
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    var components: [String] {
        let separator = "\t"
        var list = self.components(separatedBy: separator)
        
        if list.count > 0 {
            for i in 0...list.count-1 {
                list[i] = list[i].trimmed
            }
        }
        return list
    }
    
//    var componentsSeparatedByWhitespaces: [String] {
//        return self.components(separatedBy: CharacterSet.newlines)
//   }
    
//    var componentsSeparatedByNewlines: [String] {
//        return self.components(separatedBy: CharacterSet.newlines)
//    }
    
    var removeTags: String {
        var s = ""
        var l = true
        
        for c in self {
            if c == "<" { l = false }
            if l { s.append(c) }
            if c == ">" { l = true  }
        }
        return s
    }
    
    var removeLeadingChar: String {
        var s = ""
        var l = false
        
        for c in self {
            if l { s.append(c) } else { l = true }
        }
        return s
    }
    
    var removeLeadingChars: String {
        let list = self.trimmed.components(separatedBy: " ")
        
        var result: [String] = []
        for line in list {
            let s = line.removeLeadingChar
            result.append(s)
        }
        return result.joined(separator: " ")
    }
    
    var lastPathComponent: String {
        return URL(fileURLWithPath: self).lastPathComponent
    }
    
    func replace(_ string: String, _ with: String) -> String
    {
        return self.replacingOccurrences(of: string, with: with, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func mutable(attributes: [NSAttributedStringKey: Any]) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    func contains(other: String, options: SearchOption) -> Bool {
        let otherString = options.contains(.caseSensitive) ? other : other.lowercased()
        let  selfString = options.contains(.caseSensitive) ?  self :  self.lowercased()
        
        if !options.contains(.wholeWords) { return selfString.contains(otherString) }
        
        let сharacterSet = NSCharacterSet.punctuationCharacters.union(NSCharacterSet.whitespaces)
        let words = selfString.components(separatedBy: сharacterSet)
        
        for word in words {
            if word == otherString { return true }
        }
        return false
    }

    func containsEvery(list: [String], options: SearchOption) -> Bool {
        let count = list.filter { self.contains(other: $0, options: options) }.count
        return list.count == count
    }
    
    func contains(list: [String]) -> Bool {
        return list.filter { self.contains($0) }.count > 0
    }
    
    func hasSuffix(_ suffix: [String]) -> Bool {
        for item in suffix {
            if self.hasSuffix(item) { return true }
        }
        return false
    }
    
    func highlight(with: String, target: String, options: SearchOption) -> String {
        var tag = with
        tag.insert("/", at: with.index(after: with.startIndex))
        let result = self.replace(target, "\(with)\(target)\(tag)")
        if searchOption.contains(.caseSensitive) { return result }
        return result.replace(target.capitalized, "\(with)\(target.capitalized)\(tag)")
    }
    
    func highlight(with: String, target: [String], options: SearchOption) -> String {
        var result = self
        for target in target {
            result = result.highlight(with: with, target: target, options: options)
        }
        return result
    }
    
}

extension Substring {

    var int: Int {
        return Int(self) ?? 0
    }
    
    var trimmed: Substring {
        let result = self.trimmingCharacters(in: CharacterSet.whitespaces)
        return Substring(result)
    }

}

extension Collection where Iterator.Element == String {
    
    func lowercased() -> [String] {
        var result : [String] = []
        for string in self { result.append(string.lowercased()) }
        return result
    }
    
    func highlight(with: String, target: String, options: SearchOption) -> [String] {
        var result : [String] = []
        for string in self { result.append(string.highlight(with: with, target: target, options: options)) }
        return result
    }
    
}

extension NSTabView {
    func selectedTab() -> Int? {
        if let tab = self.selectedTabViewItem {
            return self.indexOfTabViewItem(tab)
        }
        return nil
    }
}

let programmatically = 1

extension NSTableView {
    func selectRow(index: Int) {
        self.tag = programmatically
        let indexSet = NSIndexSet(index: index)
        self.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        self.scrollRowToVisible(index)
        self.tag = 0
    }
}

extension UserDefaults {
    static func launchedBefore() -> Bool {
        let result = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !result {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.synchronize()
        }
        return result
    }
}

extension Array where Element == URL {
    var bookmarks : [Data] {
        var result : [Data] = []
        for url in self {
            if let bookmark = try? url.bookmarkData(options: .securityScopeAllowOnlyReadAccess, includingResourceValuesForKeys: nil, relativeTo: nil) {
                result.append(bookmark)
            }
        }
        return result
    }
    
    mutating func append(bookmarks: [Data]) {
        for bookmark in bookmarks {
            if let url = try? NSURL.init(resolvingBookmarkData: bookmark, options: .withoutUI, relativeTo: nil, bookmarkDataIsStale: nil) {
                url.startAccessingSecurityScopedResource()
                self.append(url as URL)
            }
        }
    }
}

extension NSColor {
    static var navy: NSColor {
        return NSColor(red: 0, green: 0, blue: 0.5, alpha: 1)
    }
    static var darkNavy: NSColor {
        return NSColor(red: 0, green: 0.6, blue: 1, alpha: 1)
        // midnight:   rgb(0, 24, 136);
    }
    static var systemNavy: NSColor {
        return darkAppearance ? NSColor.darkNavy : NSColor.navy
    }
}

extension NSAttributedString {
    func mutable() -> NSMutableAttributedString {
        return self.mutableCopy() as! NSMutableAttributedString
    }

    func withSystemColors() -> NSMutableAttributedString {
        let result = self.mutable()
        self.enumerateAttribute(NSAttributedStringKey.foregroundColor,
            in: NSRange(0..<self.length), options: .longestEffectiveRangeNotRequired) {
                value, range, stop in
                                            
            if let foregroundColor = value as? NSColor {
                var color: NSColor?
                switch foregroundColor {
                case NSColor.black:    color = NSColor.labelColor
                case NSColor.blue:     color = NSColor.systemBlue
                case NSColor.brown:    color = NSColor.systemBrown
                case NSColor.gray:     color = NSColor.systemGray
                case NSColor.green:    color = NSColor.systemGreen
                case NSColor.navy:     color = NSColor.systemNavy
                case NSColor.darkNavy: color = NSColor.systemNavy
                case NSColor.orange:   color = NSColor.systemOrange
                case NSColor.purple:   color = NSColor.systemPurple
                case NSColor.red:      color = NSColor.systemRed
                case NSColor.yellow:   color = NSColor.systemYellow
                default: break
                }
                if color != nil {
                    result.addAttribute(.foregroundColor, value: color!, range: range)
                }
            }
        }
        return result
    }

    func withNaturalColors() -> NSMutableAttributedString {
        let result = self.mutable()
        self.enumerateAttribute(NSAttributedStringKey.foregroundColor,
            in: NSRange(0..<self.length), options: .longestEffectiveRangeNotRequired) {
                value, range, stop in
                
            if let foregroundColor = value as? NSColor {
                var color: NSColor?
                switch foregroundColor {
                case NSColor.labelColor:   color = NSColor.black
                case NSColor.systemBlue:   color = NSColor.blue
                case NSColor.systemBrown:  color = NSColor.brown
                case NSColor.systemGray:   color = NSColor.gray
                case NSColor.systemGreen:  color = NSColor.green
                case NSColor.darkNavy:     color = NSColor.navy
                case NSColor.systemOrange: color = NSColor.orange
                case NSColor.systemPurple: color = NSColor.purple
                case NSColor.systemRed:    color = NSColor.red
                case NSColor.systemYellow: color = NSColor.yellow
                default: break
                }
                if color != nil {
                    result.addAttribute(.foregroundColor, value: color!, range: range)
                }
            }
        }
        return result
    }
    
    func copyToPasteboard() {
        let Pasteboard = NSPasteboard.general
        Pasteboard.clearContents()
        Pasteboard.writeObjects([self])
    }
}

extension NSMutableAttributedString {
    func addAttribute(_ name: NSAttributedStringKey, value: Any) {
        let range = NSRange(location: 0, length: self.length)
        self.addAttribute(name, value: value, range: range)
    }
}

extension NSAppearance {
    var isDark: Bool {
        if #available(macOS 10.14, *) {
            let appearance: NSAppearance.Name? = self.bestMatch(from: [.aqua, .darkAqua])
            return appearance == .darkAqua
        } else {
            return false
        }
    }
}

extension  FMDatabase {
    func executeQuery(_ sql: String, values: [Any]? = nil) -> FMResultSet? {
        return try? executeQuery(sql, values: values)
    }

}
