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
    
    @IBOutlet var referencesTab: NSTabViewItem!
    @IBOutlet var commentaryTab: NSTabViewItem!
    @IBOutlet var dictionaryTab: NSTabViewItem!
    
    @IBOutlet weak var bibleTextView: BibleTextView!
    @IBOutlet weak var searchTextView: СommonTextView!
    @IBOutlet weak var compareTextView: СommonTextView!
    @IBOutlet weak var referencesTextView: СommonTextView!
    @IBOutlet weak var commentaryTextView: СommonTextView!
    @IBOutlet weak var dictionaryTextView: СommonTextView!
    @IBOutlet weak var notesTextView: NotesTextView!
    
    @IBOutlet weak var popupMenu: NSMenu!
    @IBOutlet weak var interlinearItem: NSMenuItem!
    @IBOutlet weak var commentariesItem: NSMenuItem!

    var tabs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rigthView = self
        interlinearItem.title = NSLocalizedString("Interlinear", comment: "") + " (biblehub.com)"
        
        for item in tabView.tabViewItems {
            tabs.append(item.identifier as! String)
        }
        
        tabView.removeTabViewItem(searchTab)
        tabView.removeTabViewItem(referencesTab)
        tabView.removeTabViewItem(commentaryTab)
        tabView.removeTabViewItem(dictionaryTab)
    }
    
    func tabFromIdentifier(_ identifier: String) -> NSTabViewItem? {
        switch identifier {
            case "search"     : return searchTab
            case "references" : return referencesTab
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
        switch rigthView.tabView.selectedTab! {
            case "compare"    : loadCompare()
            case "references" : loadReferences()
            case "commentary" : loadCommentary()
            default : break
        }
        
    }

    func loadChapter() {
        let attrString = parse(get_Chapter(), jtag: true)
        bibleTextView.baseWritingDirection = bible!.rightToLeft ? .rightToLeft : .leftToRight
        bibleTextView.textStorage?.setAttributedString(attrString)
        leftView.makeChapterList()
        selectTab("bible")
    }
    
    func loadSearch(text: String) {
        if text.length < 2 { return }
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
        let link = bible!.verseToString(activeVerse, full: true) ?? ""
        let string = link + "\n\n" + get_Compare()
        compareTextView.textStorage?.setAttributedString(parse(string))
        selectTab("compare")
    }

    func loadReferences() {
        let link = bible!.verseToString(activeVerse, full: true) ?? ""
        let data = get_Xref()
        var string = link + "\n\n" + data
        if data.isEmpty { string += LocalizedString("Сross-references not found.") }
        referencesTextView.textStorage?.setAttributedString(parse(string))
        selectTab("references")
    }
    
    func loadCommentary() {
        let link = (bible!.verseToString(activeVerse, full: true) ?? "") + "\n\n"
        let attrString = parse(link)
        let data = get_Commentary()
        attrString.append(data)
        
        if data.string.isEmpty {
            let message = LocalizedString("Commentaries not found.") + "\n\n"
            attrString.append(parse(message))
        }
        
        if commentaries.items.isEmpty {
            let message = LocalizedString("You don't have any commentary modules.") + " " +
                          LocalizedString("For more information, choose Menu ➝ Help, then click «Unbound Bible Help».")
            attrString.append(parse(message))
        }
                
        commentaryTextView.textStorage?.setAttributedString(attrString)
        selectTab("commentary")
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
        
        if dictionaries.items.isEmpty {
            let message = LocalizedString("You don't have any dictionary modules.") + " " +
                          LocalizedString("For more information, choose Menu ➝ Help, then click «Unbound Bible Help».")
            attrString.append(parse(message))
        }
                
        dictionaryTextView.textStorage?.setAttributedString(attrString)
        selectTab("dictionary")
    }
    
}
