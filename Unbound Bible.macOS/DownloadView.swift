//
//  DownloadView.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Cocoa

class DownloadView: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    private var modules : [Module] = []

    @IBOutlet weak var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.title = "Книжная полка"
        load()
    }

    private func load() {
        for bible      in bibles       { modules.append(bible)      }
        for commentary in commentaries { modules.append(commentary) }
        for dictionary in dictionaries { modules.append(dictionary) }
        for reference  in references   { modules.append(reference ) }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return modules.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
        if tableColumn == tableView.tableColumns[0] {
            return modules[row].name
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
