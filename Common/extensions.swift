//
//  extensions.swift
//  Unbound Bible
//
//  Created by Vladimir Rybant on 18.12.2019.
//  Copyright © 2019 Vladimir Rybant. All rights reserved.
//

import Foundation

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
    
    var lastPathComponentWithoutExtension: String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    var pathExtension: String {
        return URL(fileURLWithPath: self).pathExtension
    }
    
    func replace(_ string: String, with: String) -> String
    {
        return self.replacingOccurrences(of: string, with: with, options: NSString.CompareOptions.literal, range: nil)
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
    
    func mutable(attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
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


extension FMDatabase {
    func executeQuery(_ sql: String) -> FMResultSet? {
        return try? executeQuery(sql, values: nil)
    }
}
