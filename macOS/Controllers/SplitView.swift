//
//  SplitView.swift
//  Unbound-Bible-macOS
//
//  Copyright © 2021 Vladimir Rybant Ministries. All rights reserved.
//

import Cocoa

class SplitView: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitView.autosaveName = "AutosaveSplit"
    }
    
}
