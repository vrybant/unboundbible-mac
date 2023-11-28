//
//  PopoverView.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Cocoa

class PopoverView: NSViewController {
    
    @IBOutlet weak var textView: NSTextView?
    
    static func instance() -> PopoverView? {
          let storyboard = NSStoryboard(name: String(describing: self), bundle: nil)
          return storyboard.instantiateController(withIdentifier: "PopoverViewID") as? PopoverView
    }
 
    func setAttrString( _ attrString: NSAttributedString) {
        textView?.textStorage?.setAttributedString(attrString)
    }
    
}
