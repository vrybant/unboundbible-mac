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
    @IBOutlet weak var searchTextView: СommonTextView!
    @IBOutlet weak var compareTextView: СommonTextView!
    @IBOutlet weak var notesTextView: NotesTextView!
    @IBOutlet weak var popupMenu: NSMenu!
    @IBOutlet weak var interlinearItem: NSMenuItem!
    
    var popover: NSPopover?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rigthView = self
        interlinearItem.title = NSLocalizedString("Interlinear", comment: "") + " (biblehub.com)"
//      bibleTextView.isEditable = false
//      textView.hyperlink = false
        createPopover()
    }
    
    override func viewWillAppear() {
        selectTab(at: .bible)
    }

    override func viewDidLayout() {
        bibleTextView.delegate = self
        bibleTextView.menu = popupMenu
    }
    
    func createPopover() {
        let id = NSStoryboard.SceneIdentifier(rawValue: "PopoverView")
        let controller = storyboard?.instantiateController(withIdentifier: id) as! NSViewController
        popover = NSPopover.init()
        popover?.contentViewController = controller
        popover?.behavior = .transient
//      popover?.delegate = self // we can be notified when the popover appears or closes
    }
    
    func showPopover() {
        let firstRect = bibleTextView.firstRect(forCharacterRange: bibleTextView.selectedRange, actualRange: nil)
        let converted = mainView.view.window?.convertFromScreen(firstRect)
        let rect = NSRect(x: converted!.minX, y: converted!.minY , width: 1, height: 1)
        popover?.show(relativeTo: rect, of: mainView.view, preferredEdge: .minY)
    }
    
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        mainView.refreshStatus()
        let identifier = tabView.selectedTabViewItem?.identifier as! String
        if identifier == "compare" {
            loadCompare()
        }
    }
    
}
