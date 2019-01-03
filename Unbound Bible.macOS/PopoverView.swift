//
//  PopoverView.swift
//  Unbound Bible
//
//  Copyright © 2019 Vladimir Rybant. All rights reserved.
//

import Cocoa

var popoverView = mainView.popover?.contentViewController as! PopoverView

class PopoverView: NSViewController {

    @IBOutlet var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
