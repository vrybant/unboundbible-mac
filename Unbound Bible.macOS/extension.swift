//
//  extension.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation
import Cocoa

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
    func cgfloat(forKey defaultName: String) -> CGFloat {
        return CGFloat(self.float(forKey: defaultName))
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

extension NSAttributedString {
    func mutable() -> NSMutableAttributedString {
        return self.mutableCopy() as! NSMutableAttributedString
    }

    func withSystemColors() -> NSMutableAttributedString {
        let result = self.mutable()
        self.enumerateAttribute(NSAttributedString.Key.foregroundColor,
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
                    case NSColor.teal:     color = NSColor.systemTeal
                    case NSColor.darkTeal: color = NSColor.systemTeal
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
        self.enumerateAttribute(NSAttributedString.Key.foregroundColor,
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
                    case NSColor.systemTeal:   color = NSColor.teal
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
    func addAttribute(_ name: NSAttributedString.Key, value: Any) {
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

extension NSViewController {
    var isViewVisible: Bool {
        if !isViewLoaded { return false }
        return view.window != nil
    }
}


