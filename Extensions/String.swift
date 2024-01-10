//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
#endif

extension String {
    var quoted: String {
        "\"" + self + "\""
    }
    
    var trimmed: String {
        trimmingCharacters(in: .whitespaces)
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
    
    var removeDoubleSpaces: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        return components.joined(separator: " ")
    }
    
    var lastPathComponent: String {
        URL(fileURLWithPath: self).lastPathComponent
    }
    
    var lastPathComponentWithoutExtension: String {
        URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    var pathExtension: String {
        URL(fileURLWithPath: self).pathExtension
    }
    
    func replace(_ string: String, with: String) -> String {
        replacingOccurrences(of: string, with: with, options: .literal, range: nil)
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
        list.filter { self.contains($0) }.count > 0
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
        htmlToAttributedString?.string ?? ""
    }
    
}

extension Substring {
    var int: Int {
        Int(self) ?? 0
    }
    
    var trimmed: Substring {
        let result = self.trimmingCharacters(in: CharacterSet.whitespaces)
        return Substring(result)
    }

}
