//
//  RigthViewController.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

enum Tabs: Int {
    case bible, search, compare, notes
}

func selectTab(at: Tabs) {
    rigthView.tabView.selectTabViewItem(at: at.rawValue)
}

var rigthView = RigthView() 

class RigthView: NSViewController, NSTextViewDelegate, NSTabViewDelegate {

    @IBOutlet weak var tabView: NSTabView!
    @IBOutlet weak var bibleTextView: BibleTextView!
    @IBOutlet weak var searchTextView: SuperTextView!
    @IBOutlet weak var compareTextView: SuperTextView!
    @IBOutlet weak var notesTextView: SuperTextView!
    @IBOutlet weak var popupMenu: NSMenu!

    override func viewDidLoad() {
        super.viewDidLoad()
        rigthView = self
//      bibleTextView.isEditable = false
//      textView.hyperlink = false
    }
    
    override func viewWillAppear() {
        selectTab(at: .bible)
    }

    override func viewDidLayout() {
        bibleTextView.delegate = self
        bibleTextView.menu = popupMenu
    }
    
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        mainView.updateStatus("")
        let identifier = tabView.selectedTabViewItem?.identifier as! String
        if identifier == "compare" {
            loadCompare()
        }
    }
    
}
