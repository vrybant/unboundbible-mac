//
//  SplitView.swift
//  Unbound Bible
//
//  Copyright © Vladimir Rybant Ministries. All rights reserved.
//

import Cocoa

class SplitView: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitView.autosaveName = "AutosaveSplit"
    }
    
}
