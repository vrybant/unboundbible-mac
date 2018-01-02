//
//  SplitView.swift
//  Unbound-Bible-macOS
//
//  Copyright © 2018 Vladimir Rybant Ministries. All rights reserved.
//

import Cocoa

class SplitView: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitView.autosaveName = NSSplitView.AutosaveName(rawValue: "AutosaveSplit")
    }
    
}
