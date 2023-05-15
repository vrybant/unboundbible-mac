//
//  View.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Cocoa

class View: NSView { 
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        darkAppearance = effectiveAppearance.isDark
    }
    
    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        darkAppearance = effectiveAppearance.isDark
    }
    
}
