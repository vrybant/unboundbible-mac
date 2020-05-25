//
//  RigthViewController.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

func selectTab(_ tab: String) {
    rigthView.selectTab(tab)
}

var rigthView = RigthView() 

class RigthView: NSViewController, NSTextViewDelegate, NSTabViewDelegate {

    @IBOutlet weak var tabView: NSTabView!
    
    @IBOutlet var searchTab: NSTabViewItem!
    @IBOutlet var commentaryTab: NSTabViewItem!
    @IBOutlet var dictionaryTab: NSTabViewItem!
    
    @IBOutlet weak var bibleTextView: BibleTextView!
    @IBOutlet weak var searchTextView: СommonTextView!
    @IBOutlet weak var compareTextView: СommonTextView!
    @IBOutlet weak var commentaryTextView: СommonTextView!
    @IBOutlet weak var dictionaryTextView: СommonTextView!
    @IBOutlet weak var notesTextView: NotesTextView!
    
    @IBOutlet weak var popupMenu: NSMenu!
    @IBOutlet weak var interlinearItem: NSMenuItem!
    @IBOutlet weak var commentariesItem: NSMenuItem!

    @IBAction func actionSearch(_ sender: NSMenuItem) {
        selectTab("search")
    }
    
    @IBAction func actionCommentary(_ sender: NSMenuItem) {
        selectTab("commentary")
    }
    
    @IBAction func actionDictionary(_ sender: NSMenuItem) {
        selectTab("dictionary")
    }
    
    var tabs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rigthView = self
        interlinearItem.title = NSLocalizedString("Interlinear", comment: "") + " (biblehub.com)"
        
        for item in tabView.tabViewItems {
            tabs.append(item.identifier as! String)
        }
        
        tabView.removeTabViewItem(searchTab)
        tabView.removeTabViewItem(commentaryTab)
        tabView.removeTabViewItem(dictionaryTab)
    }
    
    func tabFromIdentifier(_ identifier: String) -> NSTabViewItem? {
        switch identifier {
            case "search"     : return searchTab
            case "commentary" : return commentaryTab
            case "dictionary" : return dictionaryTab
            default           : return nil
        }
    }
    
    func showTab(tab: String) {
        let index = tabs.lastIndex(of: tab)!
        var n = index
        
        for i in 0...index-1 {
            if rigthView.tabView.indexOfTabViewItem(withIdentifier: tabs[i]) == NSNotFound {
                n -= 1
            }
        }
        tabView.insertTabViewItem(tabFromIdentifier(tab)!, at: n)
    }
    
    func selectTab(_ tab: String) {
        if tabView.indexOfTabViewItem(withIdentifier: tab) == NSNotFound { showTab(tab: tab) }
        tabView.selectTabViewItem(withIdentifier: tab)
    }
    
    override func viewDidLayout() {
        bibleTextView.delegate = self
        bibleTextView.menu = popupMenu
    }
    
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        mainView.refreshStatus()
        let identifier = tabView.selectedTabViewItem?.identifier as! String
        print(identifier)
        switch identifier {
            case "compare"    : loadCompare()
            case "commentary" : loadCommentary()
            case "dictionary" : loadDictionary()
            default : break
        }
        
    }
    
}
