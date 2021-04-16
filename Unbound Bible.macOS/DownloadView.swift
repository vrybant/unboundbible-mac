//
//  DownloadView.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Cocoa

class DownloadView: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var dict : [String] = []
    
    @IBOutlet weak var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.title = "Книжная полка"
        load()
    }

    func load() {
        for bible      in bibles       { dict.append(bible.name     ) }
        for commentary in commentaries { dict.append(commentary.name) }
        for dictionary in dictionaries { dict.append(dictionary.name) }
        for reference  in references   { dict.append(reference.name ) }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dict.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
//        if tableColumn == tableView.tableColumns[0] {
//            let cell = tableView.tableColumns[0].dataCell as? NSButtonCell
//            cell?.title = ""
//            cell?.state = bibles.bibles[row].compare ? 1 : 0
//            return cell
//        }
        
        if tableColumn == tableView.tableColumns[1] {
            return dict[row]
        }
        
        return nil
    }

    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int)
    {
//        bibles.bibles[row].compare = !bibles.bibles[row].compare
    }

    @IBAction func closeButtonAction(_ sender: NSButton) {
        dismiss(self)
        if rigthView.tabView.selectedTab == "compare" { rigthView.loadCompare() }
    }
    
}
