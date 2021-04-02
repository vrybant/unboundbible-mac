//
//  RigthViewController.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Cocoa

func selectTab(_ tab: String) {
    rigthView.selectTab(tab)
}

var rigthView = RigthView() 

class RigthView: NSViewController, NSTextViewDelegate, NSTabViewDelegate {

    @IBOutlet weak var tabView: NSTabView!
    
    @IBOutlet var searchTab: NSTabViewItem!
    @IBOutlet var referencesTab: NSTabViewItem!
    @IBOutlet var commentariesTab: NSTabViewItem!
    @IBOutlet var dictionariesTab: NSTabViewItem!
    
    @IBOutlet var bibleTextView: BibleTextView!
    @IBOutlet var searchTextView: СommonTextView!
    @IBOutlet var compareTextView: СommonTextView!
    @IBOutlet var referencesTextView: СommonTextView!
    @IBOutlet var commentariesTextView: СommonTextView!
    @IBOutlet var dictionariesTextView: СommonTextView!
    @IBOutlet var notesTextView: NotesTextView!
    
    @IBOutlet weak var popupMenu: NSMenu!
    @IBOutlet weak var commentariesItem: NSMenuItem!

    var tabs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rigthView = self
        
        for item in tabView.tabViewItems {
            tabs.append(item.identifier as! String)
        }
        
        tabView.removeTabViewItem(searchTab)
        tabView.removeTabViewItem(referencesTab)
        tabView.removeTabViewItem(commentariesTab)
        tabView.removeTabViewItem(dictionariesTab)
        
        bibleTextView.delegate = self
        searchTextView.delegate = self
        compareTextView.delegate = self
        referencesTextView.delegate = self
        commentariesTextView.delegate = self
        dictionariesTextView.delegate = self
        notesTextView.delegate = self
        
        bibleTextView.menu = popupMenu
        searchTextView.menu = popupMenu
        compareTextView.menu = popupMenu
        referencesTextView.menu = popupMenu
        commentariesTextView.menu = popupMenu
        dictionariesTextView.menu = popupMenu
        notesTextView.menu = popupMenu
    }
    
    var selectedString: String {
        switch rigthView.tabView.selectedTab! {
            case "bible"        : return bibleTextView.selectedString
            case "search"       : return searchTextView.selectedString
            case "compare"      : return compareTextView.selectedString
            case "references"   : return referencesTextView.selectedString
            case "commentaries" : return commentariesTextView.selectedString
            case "dictionaries" : return dictionariesTextView.selectedString
            case "notes"        : return notesTextView.selectedString
            default             : return ""
        }
    }
    
    func tabFromIdentifier(_ identifier: String) -> NSTabViewItem? {
        switch identifier {
            case "search"       : return searchTab
            case "references"   : return referencesTab
            case "commentaries" : return commentariesTab
            case "dictionaries" : return dictionariesTab
            default             : return nil
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
    
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        mainView.refreshStatus()
        let tab = tabView.selectedTab!
        switch tab {
            case "compare"      : loadCompare()
            case "references"   : loadReferences()
            case "commentaries" : loadCommentary()
            default : break
        }
        winController.searchOptionsButton.isEnabled = tab != "dictionaries"
    }

    func textView(_ view: NSTextView, menu: NSMenu, for event: NSEvent, at charIndex: Int) -> NSMenu? {
        return popupMenu
    }
    
    func loadChapter() {
        let attrString = parse(get_Chapter(), jtag: true)
        bibleTextView.baseWritingDirection = currBible!.rightToLeft ? .rightToLeft : .leftToRight
        bibleTextView.textStorage?.setAttributedString(attrString)
        leftView.makeChapterList()
        selectTab("bible")
    }
    
    func loadSearch(text: String) {
        if text.count < 2 { return }
        let data = get_Search(string: text)
        var string = data.string

        if data.count == 0 {
            let message = LocalizedString("You search for % produced no results.")
            string = "\(message.replace("%", with: text.quoted))"
        }

        searchTextView.textStorage?.setAttributedString(parse(string))
        leftView.makeChapterList()
        selectTab("search")
        
        let status = LocalizedString("verses was found")
        mainView.updateStatus("\(data.count) \(status)")
    }
 
    func loadCompare() {
        let link = currBible!.verseToString(currVerse, full: true) ?? ""
        let string = link + "\n\n" + get_Compare()
        compareTextView.textStorage?.setAttributedString(parse(string))
        selectTab("compare")
    }

    func loadReferences() {
        let link = currBible!.verseToString(currVerse, full: true) ?? ""
        let values = get_References()
        var string = link + "\n\n" + values.string
        if values.string.isEmpty { string += LocalizedString("Сross-references not found.") }
        referencesTextView.textStorage?.setAttributedString(parse(string))
        selectTab("references")
        mainView.updateStatus(values.info)
    }
    
    func loadCommentary() {
        let link = (currBible!.verseToString(currVerse, full: true) ?? "") + "\n\n"
        let attrString = parse(link)
        let data = get_Commentary()
        attrString.append(data)
        
        if data.string.isEmpty {
            let message = LocalizedString("Commentaries not found.") + "\n\n"
            attrString.append(parse(message))
        }
        
        if commentaries.footnotesOnly {
            let message = LocalizedString("You don't have any commentary modules.") + " " +
                          LocalizedString("For more information, choose Menu ➝ Help, then click «Modules Downloads».")
            attrString.append(parse(message))
        }
                
        commentariesTextView.textStorage?.setAttributedString(attrString)
        selectTab("commentaries")
    }
    
    func loadDictionary(key: String) {
        let attrString = "".attributed
        let data = get_Dictionary(key: key)
        attrString.append(data)
        
        if data.string.isEmpty {
            var message = LocalizedString("You search for % produced no results.") + "\n\n"
            message = "\(message.replace("%", with: key.quoted))"
            attrString.append(parse(message))
        }
        
        if dictionaries.embeddedOnly {
            let message = LocalizedString("You don't have any dictionary modules.") + " " +
                          LocalizedString("For more information, choose Menu ➝ Help, then click «Modules Downloads».")
            attrString.append(parse(message))
        }
                
        dictionariesTextView.textStorage?.setAttributedString(attrString)
        selectTab("dictionaries")
    }
    
}
