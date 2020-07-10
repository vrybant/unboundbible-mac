//
//  DownloadView.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

class DownloadView: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    let dict = [
        "Albanian Bible",
        "Arabic Van Dyck Bible", "Bulgarian Bible",
        "Chinese Union Version (Simplified)",
        "Chinese Union Version (Traditional)",
        "Czech Bible",
        "Danish Bible",
        "Dutch Staten Vertaling",
            "American Standart Version",
            "Bible in Basic English",
            "Bishops' Bible",  // with apocrypha
            "Darby Bible",
            "Geneva Bible",    // with apocrypha
            "King James Version",
            "King James Version with Apocrypha",
            "World English Bible",
        "Finish Pyhä Raamattu", // Suomi
        "French Darby Bible",
        "French Louis Segond Bible",
        "German Elberfelder Bible 1905",
        "German Luther Bible 1912 ",
        "Greek (Modern) Vamvas Bible 1850",
        "Greek New Testament 1904",
        "Greek New Testament (Textus Receptus)",
        "Greek Old Testament (Septuagint)",
        "Hebrew New Testament",
        "Hebrew New Testament",
        "Hebrew Old Testament (Tanach)",
        "Hungarian Károli Bible ",
        "Italian Riveduta Luzzi 1925",
        "Japanese Kougo-yaku 1954/1955",
        "Japanese Shinkaiyaku Seisho 1954/1955",
        "Latin Vulgate",
        "Norwegian Bible",
        "Polish Bible Gdanska",
        "Portuguese João Ferreira de Almeida Atualizada",
        "Portuguese João Ferreira de Almeida Corrigida",
        "Romanian Dumitru Cornilescu Translation",
        "Romanian Orthodox Bible",
        "Russian Synodal Bible",
        "Serbian Daničić Karadžić (Latin script)",
        "Spanish Reina Valera 1909",
        "Swedish Bible 1917",
        "Ukrainian Bible 1930",
        "Vietnamese Bible 1934"
    ]
    
    @IBOutlet weak var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return dict.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
//        if tableColumn == tableView.tableColumns[0] {
//            let cell = tableView.tableColumns[0].dataCell as? NSButtonCell
//            cell?.title = ""
//            cell?.state = shelf.bibles[row].compare ? 1 : 0
//            return cell
//        }
        
        if tableColumn == tableView.tableColumns[1] {
            return dict[row]
        }
        
        return nil
    }

    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int)
    {
//        shelf.bibles[row].compare = !shelf.bibles[row].compare
    }

    @IBAction func closeButtonAction(_ sender: NSButton) {
        dismiss(self)
        if rigthView.tabView.selectedTab() == "compare" { rigthView.loadCompare() }
    }
    
}
