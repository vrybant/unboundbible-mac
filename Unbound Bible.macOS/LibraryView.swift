//
//  LibraryView.swift
//  Unbound Bible
//
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import Cocoa

class LibraryView: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return shelf.bibles.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
        if tableColumn == tableView.tableColumns[0] {
            let cell = tableView.tableColumns[0].dataCell as? NSButtonCell
            cell?.title = ""
            cell?.state = NSControl.StateValue(rawValue: shelf.bibles[row].compare ? 1 : 0)
            return cell
        }

        if tableColumn == tableView.tableColumns[1] {
            return shelf.bibles[row].name
        }
        
        return nil
    }
    
    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int)
    {
        shelf.bibles[row].compare = !shelf.bibles[row].compare
    }
    
    @IBAction func closeButtonAction(_ sender: NSButton) {
        dismiss(self)
        if rigthView.tabView.selectedTab == "compare" { rigthView.loadCompare() }
    }
    
}
