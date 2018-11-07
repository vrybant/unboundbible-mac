//
//  View.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

var darkAppearance: Bool = false

class View: NSView {
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        darkAppearance = self.effectiveAppearance.isDark
    }
    
    override func draw(_ dirtyRect: NSRect) {
        darkAppearance = self.effectiveAppearance.isDark
        super.draw(dirtyRect)
    }
}
