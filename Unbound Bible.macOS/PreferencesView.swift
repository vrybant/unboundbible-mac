//
//  PreferencesView.swift
//  Unbound Bible
//
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import Cocoa

var preferencesView = PreferencesView()

class PreferencesView: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        preferencesView = self
    }

    override func viewDidAppear() {
        super.viewWillAppear()
    }

}
