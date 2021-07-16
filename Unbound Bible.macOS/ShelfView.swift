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
        let row = tableView.selectedRow
        deleteButton.isEnabled = currBible?.name != modules[row].name
        updateLabels()
    }
    
    func deleteModule(module: Module) {
        if module is Bible      {        bibles.deleteItem(module as! Bible      ) }
        if module is Commentary {  commentaries.deleteItem(module as! Commentary ) }
        if module is Dictionary {  dictionaries.deleteItem(module as! Dictionary ) }
        if module is Reference  {    references.deleteItem(module as! Reference  ) }
        
        modules.removeAll(where: { $0 === module })
        tableView.reloadData()
    }
    
    @IBAction func deleteButton(_ sender: NSButtonCell) {
        var row = tableView.selectedRow
        let alert = NSAlert()
        alert.messageText = LocalizedString("Do you wish to delete this module?")
        alert.informativeText = modules[row].name
        alert.addButton(withTitle: LocalizedString("Cancel"))
        alert.addButton(withTitle: LocalizedString("Delete"))
        if alert.runModal() == .alertFirstButtonReturn { return } // Cancel
        deleteModule(module: modules[row])
        if row == modules.count { row -= 1 }
        tableView.selectRow(index: row)
        leftView.loadBibleMenu()
    }
    
}

extension ShelfView: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return modules.count
    }

}

extension ShelfView: NSTableViewDelegate {
    
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
