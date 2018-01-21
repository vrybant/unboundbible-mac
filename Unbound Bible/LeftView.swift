//
//  LeftViewController.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

var leftView = LeftView()

class LeftView: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var popUpButton: NSPopUpButton!
    @IBOutlet weak var bookTableView: NSTableView!
    @IBOutlet weak var chapterTableView: NSTableView!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
//    var width: CGFloat = 0
    
    var bookTableViewList: [String] = []
    var chapterTableViewCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftView = self
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        let width = self.view.bounds.width
        constraint.constant = width - 13
    }
        
    func bibleMenuInit() {
        popUpButton.removeAllItems()
        for item in shelf.bibles {
            popUpButton.addItem(withTitle: item.name)
        }
        popUpButton.selectItem(at: current)
    }
    
    func makeBookList() {
        bookTableViewList = shelf.bibles[current].getTitles()
        bookTableView.reloadData()
    }
    
    func makeChapterList(n: Int) {
        if n != chapterTableViewCount {
            chapterTableViewCount = n
            chapterTableView.reloadData()
            chapterTableView.selectRow(index: 0)
        }
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        var count: Int?
        if tableView == bookTableView { count = bookTableViewList.count }
        if tableView == chapterTableView { count = chapterTableViewCount }
        return count!
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellView: NSTableCellView?
        
        if tableView == bookTableView {
            cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellbook"), owner: self) as? NSTableCellView
            cellView?.textField!.stringValue = bookTableViewList[row]
            return cellView
        }

        if tableView == chapterTableView {
            cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellchapter"), owner: self) as? NSTableCellView
            cellView?.textField!.stringValue = String(row+1)
            return cellView
        }
        
        return cellView!
    }
    
    func chapterTableView(_ chapterTableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let cellView = chapterTableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: self) as! NSTableCellView
        cellView.textField!.stringValue = String(row)
        return cellView
    }
    
    @IBAction func popUpButtonAction(_ sender: NSPopUpButton) {
        shelf.setCurrent(sender.indexOfSelectedItem)
        mainView.updateStatus(shelf.bibles[current].info)
        makeBookList()
        goToVerse(activeVerse, select: activeVerse.number > 1)
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableView = notification.object as! NSTableView
        
        if tableView == bookTableView {
            if tableView.tag != programmatically {
                let name = bookTableViewList[bookTableView.selectedRow]
                if let book = shelf.bibles[current].bookByName(name) {
                    activeVerse = Verse(book: book, chapter: 1, number: 1, count: 1)
                }
            }
        }
        
        if tableView == chapterTableView {
            if tableView.tag != programmatically {
                if tableView.selectedRow > 0 {
                    let chapter = tableView.selectedRow + 1
                    activeVerse = Verse(book: activeVerse.book, chapter: chapter, number: 1, count: 1)
                }
            }
        }
        
        load_Chapter()
    }
    
    func load_Chapter() {
        loadChapter()
        makeChapterList(n: shelf.bibles[current].chapterCount(activeVerse))
        selectTab(at: .bible)
    }

}
