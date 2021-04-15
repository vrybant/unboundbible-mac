//
//  LibraryView.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Cocoa

class LibraryView: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return bibles.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
        if tableColumn == tableView.tableColumns[0] {
            let cell = tableView.tableColumns[0].dataCell as? NSButtonCell
            cell?.title = ""
            cell?.state = NSControl.StateValue(rawValue: bibles[row].favorite ? 1 : 0)
            return cell
        }

        if tableColumn == tableView.tableColumns[1] {
            return bibles[row].name
        }
        
        return nil
    }
    
    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int)
    {
        bibles[row].favorite = !bibles[row].favorite
    }
    
    @IBAction func closeButtonAction(_ sender: NSButton) {
        dismiss(self)
        if rigthView.tabView.selectedTab == "compare" { rigthView.loadCompare() }
    }
    
}
