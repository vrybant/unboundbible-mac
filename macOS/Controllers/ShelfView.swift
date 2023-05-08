//
//  DownloadView.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Cocoa

class ShelfView: NSViewController {
    
    private var modules : [Module] = []

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var filenameLabel: NSTextField!
    @IBOutlet weak var infoLabel: NSTextField!
    @IBOutlet weak var deleteButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modules = tools.get_Modules()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.selectRow(index: 0)
        updateLabels()
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
        let row = tableView.selectedRow
        deleteButton.isEnabled = currBible?.name != modules[row].name
        updateLabels()
    }
    
    @IBAction func deleteButton(_ sender: NSButtonCell) {
        var row = tableView.selectedRow
        let alert = NSAlert()
        alert.messageText = LocalizedString("Do you wish to delete this module?")
        alert.informativeText = modules[row].name
        alert.addButton(withTitle: LocalizedString("Cancel"))
        alert.addButton(withTitle: LocalizedString("Delete"))
        
        if alert.runModal() == .alertSecondButtonReturn {
            let module = modules[row]
            tools.deleteModule(module: module)
            modules.removeAll(where: { $0 === module })
            if row == modules.count { row -= 1 }
            tableView.reloadData()
            tableView.selectRow(index: row)
            leftView.loadBibleMenu()
        }
    }
    
}

extension ShelfView: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        modules.count
    }

}

extension ShelfView: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellView: NSTableCellView?
        
        if tableColumn?.identifier.rawValue == "NameColumn" {
            let id = NSUserInterfaceItemIdentifier(rawValue: "NameCell")
            cellView = tableView.makeView(withIdentifier: id, owner: self) as? NSTableCellView
            cellView?.textField?.stringValue = modules[row].name
        }
        
        if tableColumn?.identifier.rawValue == "LangColumn" {
            let id = NSUserInterfaceItemIdentifier(rawValue: "LangCell")
            cellView = tableView.makeView(withIdentifier: id, owner: self) as? NSTableCellView
            cellView?.textField?.stringValue = modules[row].language
        }

        return cellView
    }

}
