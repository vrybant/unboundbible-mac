//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

extension NSAttributedString {
    func mutable() -> NSMutableAttributedString {
        mutableCopy() as! NSMutableAttributedString
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

extension NSMutableAttributedString {
    func addAttribute(_ name: NSAttributedString.Key, value: Any) {
        let range = NSRange(location: 0, length: self.length)
        self.addAttribute(name, value: value, range: range)
    }
}
