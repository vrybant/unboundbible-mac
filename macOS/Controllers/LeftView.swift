//
//  LeftViewController.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
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
        
    func loadBibleMenu() { 
        popUpButton.removeAllItems()
        var index = 0
        let names = tools.bibles.getNames()
        for name in names {
            popUpButton.addItem(withTitle: name)
            if name == currBible.name { popUpButton.selectItem(at: index) }
            index += 1
        }
    }
    
    func makeBookList() {
        bookTableViewList = currBible.getTitles()
        bookTableView.reloadData()
        writingDirection = currBible.rightToLeft ? .rightToLeft : .leftToRight
    }
    
    func makeChapterList() {
        let n = currBible.chaptersCount(book: currVerse.book)
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
            let id = NSUserInterfaceItemIdentifier(rawValue: "cellbook")
            cellView = tableView.makeView(withIdentifier: id, owner: self) as? NSTableCellView
            cellView?.textField!.stringValue = bookTableViewList[row]
            cellView?.textField!.baseWritingDirection = writingDirection
            let width = tableView.frame.width
            tableView.tableColumns[0].width = width - 12
        }

        if tableView == chapterTableView {
            let id = NSUserInterfaceItemIdentifier(rawValue: "cellchapter")
            cellView = tableView.makeView(withIdentifier: id, owner: self) as? NSTableCellView
            cellView?.textField!.stringValue = String(row+1)
        }
        
        return cellView
    }
   
    @IBAction func popUpButtonAction(_ sender: NSPopUpButton) {
        tools.setCurrBible(popUpButton.selectedItem!.title)
        makeBookList()
        showCurrVerse(select: currVerse.number > 1)
        mainView.updateStatus(currBible.fileName + " | " + currBible.info)
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableView = notification.object as! NSTableView
        if tableView.selectedRow < 0 { return }

        if tableView == bookTableView {
            if tableView.tag != programmatically {
                let name = bookTableViewList[tableView.selectedRow]
                if let book = currBible.bookByName(name) {
                    currVerse = Verse(book: book, chapter: 1, number: 1, count: 1)
                }
            }
        }
        
        if tableView == chapterTableView {
            if tableView.tag != programmatically {
                if tableView.selectedRow >= 0 {
                    let chapter = tableView.selectedRow + 1
                    currVerse = Verse(book: currVerse.book, chapter: chapter, number: 1, count: 1)
                }
            }
        }
        
        rigthView.loadChapter()
    }
    
    func selectBible(name: String) -> Bool {
        if !popUpButton.itemTitles.contains(name) { return false }
        popUpButton.selectItem(withTitle: name)
        popUpButtonAction(popUpButton)
        return true
    }
    
    func showCurrVerse(select: Bool) {
        if let index = currBible.idxByNum(currVerse.book) {
            bookTableView.selectRow(index: index)
            chapterTableView.selectRow(index: currVerse.chapter - 1)
            if select {
                rigthView.bibleTextView.selectParagraph(number: currVerse.number)
            }
            selectTab("bible")
        }

    }
    
}
