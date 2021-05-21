//
//  DownloadView.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Cocoa

class DownloadView: NSViewController {
    
    private var modules : [Module] = []

    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.title = "Книжная полка"
        
        load()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func load() {
        for bible      in bibles       { modules.append(bible)      }
        for commentary in commentaries { modules.append(commentary) }
        for dictionary in dictionaries { modules.append(dictionary) }
        for reference  in references   { modules.append(reference ) }
    }
    
    @IBAction func closeButtonAction(_ sender: NSButton) {
        dismiss(self)
        if rigthView.tabView.selectedTab == "compare" { rigthView.loadCompare() }
    }
    
}

extension DownloadView: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return modules.count
    }

}

extension DownloadView: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        if tableColumn?.identifier.rawValue == "NameColumn" {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "NameCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = modules[row].name
            return cellView
        }
        
        if tableColumn?.identifier.rawValue == "LangColumn" {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "LangCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = modules[row].language
            return cellView
        }

        return nil
    }

}
