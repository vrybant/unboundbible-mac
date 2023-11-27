//
//  PopoverView.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Cocoa

var popoverView = PopoverView.instance()

class PopoverView: NSViewController {
    
    @IBOutlet var textView: NSTextView!
    
    static func instance() -> PopoverView? {
          let storyboard = NSStoryboard(name: String(describing: self), bundle: nil)
          return storyboard.instantiateController(withIdentifier: "PopoverViewID") as? PopoverView
    }
    
}
