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
    
/*  procedure TShelfForm.ToolButtonDeleteClick(Sender: TObject);
    begin
      if QuestionDlg(' ' + T('Confirmation'),
        T('Do you wish to delete this module?') + LineBreaker + LineBreaker +
          Modules[StringGrid.Row].name + LineBreaker, mtWarning, [mrYes, T('Delete'), mrCancel, T('Cancel'), 'IsDefault'], 0) = idYes then
              begin
                DeleteModule(Modules[StringGrid.Row]);
                Modules.Delete(StringGrid.Row);
                StringGrid.DeleteRow(StringGrid.Row);
                StringGridSelection(Sender, StringGrid.Col, StringGrid.Row);
              end;
    end; */
    
    func deleteModule(module: Module) {
    
        print(modules.count)
        modules.removeAll(where: { $0 === module })
        print(modules.count)

        if module is Bible      {        bibles.deleteItem(module as! Bible      ) }
        if module is Commentary {  commentaries.deleteItem(module as! Commentary ) }
        if module is Dictionary {  dictionaries.deleteItem(module as! Dictionary ) }
        if module is Reference  {    references.deleteItem(module as! Reference  ) }
    }
    
    @IBAction func deleteButton(_ sender: NSButtonCell) {
        let row = tableView.selectedRow
        print(modules[row].name)
        deleteModule(module: modules[row])
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
