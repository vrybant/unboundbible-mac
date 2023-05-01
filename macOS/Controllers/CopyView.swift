//
//  CopyView.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Cocoa

var copyView = CopyView()

class CopyView: NSViewController {

    @IBOutlet var textView: NSTextView!
    
    @IBOutlet weak var abbreviateButton: NSButton!
    @IBOutlet weak var enumeratedButton: NSButton!
    @IBOutlet weak var guillemetsButton: NSButton!
    @IBOutlet weak var parenthesesButton: NSButton!
    @IBOutlet weak var endingButton: NSButton!
    @IBOutlet weak var defaultButton: NSButton!
    
    var options: CopyOptions = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        copyView = self
    }
    
    override func viewWillAppear() { 
        view.window?.styleMask.remove(NSWindow.StyleMask.fullScreen)
        view.window?.styleMask.remove(NSWindow.StyleMask.resizable )
        view.window?.styleMask.remove(NSWindow.StyleMask.closable  )
        
        view.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        view.window?.standardWindowButton(.zoomButton       )?.isHidden = true
        view.window?.standardWindowButton(.closeButton      )?.isHidden = true
        
        options = copyOptions
        
         abbreviateButton.state = NSControl.StateValue(rawValue: options.contains(.abbreviate ) ? 1 : 0)
         enumeratedButton.state = NSControl.StateValue(rawValue: options.contains(.enumerate  ) ? 1 : 0)
         guillemetsButton.state = NSControl.StateValue(rawValue: options.contains(.guillemets ) ? 1 : 0)
        parenthesesButton.state = NSControl.StateValue(rawValue: options.contains(.parentheses) ? 1 : 0)
             endingButton.state = NSControl.StateValue(rawValue: options.contains(.endinglink ) ? 1 : 0)
        
        if tools.bibles.isEmpty { return }
        
        textView.baseWritingDirection = currBible!.rightToLeft ? .rightToLeft : .leftToRight
        textView.textStorage?.setAttributedString(tools.get_Verses(options: options))
    }
    
    @IBAction func checkButtonAction(_ sender: NSButton) {
        options = []
        
        if  abbreviateButton.state.rawValue == 1 { options.insert(.abbreviate ) }
        if  enumeratedButton.state.rawValue == 1 { options.insert(.enumerate  ) }
        if  guillemetsButton.state.rawValue == 1 { options.insert(.guillemets ) }
        if parenthesesButton.state.rawValue == 1 { options.insert(.parentheses) }
        if      endingButton.state.rawValue == 1 { options.insert(.endinglink ) }
        
        textView.textStorage?.setAttributedString(tools.get_Verses(options: options))
    }
    
    @IBAction func copyButtonAction(_ sender: NSButton) {
        tools.get_Verses(options: options).copyToPasteboard()
        if defaultButton.state.rawValue == 1 { copyOptions = options }
        self.dismiss(self)
    }
    
    @IBAction func cancelButtonAction(_ sender: NSButton) {
        self.dismiss(self)
    }
    
}
