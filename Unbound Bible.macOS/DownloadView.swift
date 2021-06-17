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
    @IBOutlet weak var filenameLabel: NSTextField!
    @IBOutlet weak var infoLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.selectRow(index: 0)
        updateLabels()
    }

    private func load() {
        for bible      in bibles       { modules.append(bible)      }
        for commentary in commentaries { modules.append(commentary) }
        for dictionary in dictionaries { modules.append(dictionary) }
        for reference  in references   { modules.append(reference ) }
    }
    
    func updateLabels() {
        let row = tableView.selectedRow
        let label = LocalizedString("File Name") + " : "
        filenameLabel.stringValue = label + modules[row].fileName
        infoLabel.stringValue = modules[row].info
    }
    
    func tableViewSelectionIsChanging(_ notification: Notification) {
        updateLabels()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateLabels()
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
