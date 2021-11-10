//
//  extensions.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
#endif

extension Int32 {
    var int: Int {
        return Int(self)
    }
}

extension Array where Element == URL {
    var bookmarks : [Data] {
        var result : [Data] = []
        for url in self {
            if let bookmark = try? url.bookmarkData( /* options: .securityScopeAllowOnlyReadAccess, */ includingResourceValuesForKeys: nil, relativeTo: nil) {
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

extension String {
    
    var quoted: String {
        return "\"" + self + "\""
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespaces)
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
    
    var removeTags: String {
        var s = ""
        var l = true
        
        for c in self {
            if c == "<" { l = false }
            if l { s += String(c) } 
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
    
    var removeDoubleSpace: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        return components.joined(separator: " ")
    }
    
    var lastPathComponent: String {
        return URL(fileURLWithPath: self).lastPathComponent
    }
    
    var lastPathComponentWithoutExtension: String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    var pathExtension: String {
        return URL(fileURLWithPath: self).pathExtension
    }
    
    var attributed: NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: defaultAttributes)
    }
    
    func replace(_ string: String, with: String) -> String
    {
        return self.replacingOccurrences(of: string, with: with, options: .literal, range: nil)
    }

    func cut(from: String, to: String) -> String {
        var string = self
        while string.contains(from) {
            guard let lower = string.range(of: from)?.lowerBound else { break }
            guard let upper = string.range(of:   to)?.upperBound else { break }
            if lower > upper { break }
            let prefix = string.prefix(upTo: lower)
            let suffix = string.suffix(from: upper)
            string = String(prefix + suffix)
        }
        return string
    }
    
    func contains(other: String, options: SearchOption) -> Bool {
        let otherString = options.contains(.caseSensitive) ? other : other.lowercased()
        let  selfString = options.contains(.caseSensitive) ?  self :  self.lowercased()
        
        if !options.contains(.wholeWords) { return selfString.contains(otherString) }
        
        let сharacterSet = NSCharacterSet.punctuationCharacters.union(.whitespaces)
        let words = selfString.components(separatedBy: сharacterSet)
        
        for word in words {
            if word == otherString { return true }
        }
        return false
    }

    func containsEvery(_ list: [String], options: SearchOption) -> Bool {
        let count = list.filter { self.contains(other: $0, options: options) }.count
        return list.count == count
    }
    
    func containsAny(_ list: [String]) -> Bool {
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
        let result = self.replace(target, with: "\(with)\(target)\(tag)")
        if searchOption.contains(.caseSensitive) { return result }
        return result.replace(target.capitalized, with: "\(with)\(target.capitalized)\(tag)")
    }
    
    func highlight(with: String, target: [String], options: SearchOption) -> String {
        var result = self
        for target in target {
            result = result.highlight(with: with, target: target, options: options)
        }
        return result
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}

extension NSMutableAttributedString {
    func addAttribute(_ name: NSAttributedString.Key, value: Any) {
        let range = NSRange(location: 0, length: self.length)
        self.addAttribute(name, value: value, range: range)
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

extension Color {
    static var navy: Color {
        return Color(red: 0, green: 0, blue: 0.5, alpha: 1)
    }
    static var darkNavy: Color {
        return Color(red: 0, green: 0.6, blue: 1, alpha: 1)
    }
    static var systemNavy: Color {
        return darkAppearance ? Color.darkNavy : Color.navy
    }
    static var teal: Color {
        return Color(red: 0.2, green: 0.4, blue: 0.4, alpha: 1)
    }
    static var darkTeal: Color {
        return Color(red:0.40, green:0.80, blue:0.80, alpha: 1)
    }
    static var systemTeal: Color {
        return darkAppearance ? Color.darkTeal : Color.teal
    }
    static var systemAccent: Color {
        if #available(OSX 10.14, *) {
            #if os(OSX)
                return controlAccentColor
            #else
                return systemNavy // ???
            #endif
        } else {
            return systemNavy
        }
    }
}

#if os(iOS)
extension Color {
    static var systemBrown: Color {
        return Color.brown
    }
    static var labelColor: Color {
        return Color.label
    }
    static var secondaryLabelColor: Color {
        return Color.secondaryLabel
    }
}
#endif

extension NSAttributedString {
    func mutable() -> NSMutableAttributedString {
        return self.mutableCopy() as! NSMutableAttributedString
    }

    func withSystemColors() -> NSMutableAttributedString {
        let result = self.mutable()
        self.enumerateAttribute(NSAttributedString.Key.foregroundColor,
            in: NSRange(0..<self.length), options: .longestEffectiveRangeNotRequired) {
                value, range, stop in
                                            
            if let foregroundColor = value as? Color {
                var color: Color?
                switch foregroundColor {
                    case Color.black:    color = Color.labelColor
                    case Color.blue:     color = Color.systemBlue
                    case Color.brown:    color = Color.systemBrown
                    case Color.gray:     color = Color.systemGray
                    case Color.green:    color = Color.systemGreen
                    case Color.navy:     color = Color.systemNavy
                    case Color.darkNavy: color = Color.systemNavy
                    case Color.orange:   color = Color.systemOrange
                    case Color.purple:   color = Color.systemPurple
                    case Color.red:      color = Color.systemRed
                    case Color.teal:     color = Color.systemTeal
                    case Color.darkTeal: color = Color.systemTeal
                    case Color.yellow:   color = Color.systemYellow
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
                
            if let foregroundColor = value as? Color {
                var color: Color?
                switch foregroundColor {
                    case Color.labelColor:   color = Color.black
                    case Color.systemBlue:   color = Color.blue
                    case Color.systemBrown:  color = Color.brown
                    case Color.systemGray:   color = Color.gray
                    case Color.systemGreen:  color = Color.green
                    case Color.darkNavy:     color = Color.navy
                    case Color.systemOrange: color = Color.orange
                    case Color.systemPurple: color = Color.purple
                    case Color.systemRed:    color = Color.red
                    case Color.systemTeal:   color = Color.teal
                    case Color.systemYellow: color = Color.yellow
                    default: break
                }
                if color != nil {
                    result.addAttribute(.foregroundColor, value: color!, range: range)
                }
            }
        }
        return result
    }
    
}

extension UserDefaults {
    func cgfloat(forKey defaultName: String) -> CGFloat {
        return CGFloat(self.float(forKey: defaultName))
    }
}

extension FMDatabase {
    func executeQuery(_ sql: String) -> FMResultSet? {
        return try? executeQuery(sql, values: nil)
    }
}

extension FMResultSet {
    
    func columnExist(_ name: String) -> Bool {
        let name = name.lowercased()
        let map = self.columnNameToIndexMap
        return map[name] != nil
    }
    
    func asString(forColumn name: String) -> String? {
        if !columnExist(name) { return nil }
        return self.string(forColumn: name)
    }
    
    func asBool(forColumn name: String) -> Bool {
        if !columnExist(name) { return false }
        return self.bool(forColumn: name)
    }

}
