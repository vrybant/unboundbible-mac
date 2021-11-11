//
//  WelcomeView.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Cocoa

class WelcomeView: NSViewController {
    
    override func viewWillAppear() {
        view.window?.styleMask.remove(NSWindow.StyleMask.fullScreen)
        view.window?.styleMask.remove(NSWindow.StyleMask.resizable )
        view.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        view.window?.standardWindowButton(.zoomButton       )?.isHidden = true
    }
    
    @IBAction func closeAction(_ sender: NSButton) {
        dismiss(self)
    }
    
}
