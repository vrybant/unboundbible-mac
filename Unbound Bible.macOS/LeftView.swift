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
    @IBOutlet weak var textFieldCell: NSTextFieldCell!
    
    var bookTableViewList: [String] = []
    var chapterTableViewCount: Int = 0
    var writingDirection : NSWritingDirection = .leftToRight

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
        popUpButton.selectItem(at: shelf.current)
    }
    
    func makeBookList() {
        bookTableViewList = bible!.getTitles()
        bookTableView.reloadData()
        writingDirection = bible!.rightToLeft ? .rightToLeft : .leftToRight
    }
    
    func makeChapterList() {
        let n = bible!.chapterCount(activeVerse)
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
            cellView?.textField!.baseWritingDirection = writingDirection
            return cellView
        }

        if tableView == chapterTableView {
            cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellchapter"), owner: self) as? NSTableCellView
            cellView?.textField!.stringValue = String(row+1)
            return cellView
        }
        
        return cellView!
    }
    
    @IBAction func popUpButtonAction(_ sender: NSPopUpButton) {
        if shelf.isEmpty { return }
        shelf.setCurrent(sender.indexOfSelectedItem)
        mainView.updateStatus(bible!.fileName + " | " + bible!.info)
        makeBookList()
        goToVerse(activeVerse, select: activeVerse.number > 1)
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableView = notification.object as! NSTableView
        if tableView.selectedRow < 0 { return }

        if tableView == bookTableView {
            if tableView.tag != programmatically {
                let name = bookTableViewList[tableView.selectedRow]
                if let book = bible!.bookByName(name) {
                    activeVerse = Verse(book: book, chapter: 1, number: 1, count: 1)
                }
            }
        }
        
        if tableView == chapterTableView {
            if tableView.tag != programmatically {
                if tableView.selectedRow >= 0 {
                    let chapter = tableView.selectedRow + 1
                    activeVerse = Verse(book: activeVerse.book, chapter: chapter, number: 1, count: 1)
                }
            }
        }
        
        rigthView.loadChapter() 
    }
    
}
