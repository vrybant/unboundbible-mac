//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

extension Color {
    static var navy: Color {
        Color(red: 0, green: 0, blue: 0.5, alpha: 1)
    }
    static var darkNavy: Color {
        Color(red: 0, green: 0.6, blue: 1, alpha: 1)
    }
    static var systemNavy: Color {
        darkAppearance ? Color.darkNavy : Color.navy
    }
    static var teal: Color {
        Color(red: 0.2, green: 0.4, blue: 0.4, alpha: 1)
    }
    static var darkTeal: Color {
        Color(red:0.40, green:0.80, blue:0.80, alpha: 1)
    }
    static var systemTeal: Color {
        darkAppearance ? Color.darkTeal : Color.teal
    }
    static var systemAccent: Color {
        if #available(OSX 10.14, *) {
            #if COCOA
                return controlAccentColor
            #else
                return systemNavy // ???
            #endif
        } else {
            return systemNavy
        }
    }
}

#if !COCOA
extension Color {
    static var systemBrown: Color {
        Color.brown
    }
    static var labelColor: Color {
        Color.label
    }
    static var secondaryLabelColor: Color {
        Color.secondaryLabel
    }
}
#endif
