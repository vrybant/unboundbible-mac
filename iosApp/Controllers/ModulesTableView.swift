//
//  ModulesTableView.swift
//  iOSApp
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import UIKit

// https://stackoverflow.com/questions/10054865/trying-to-add-3rd-tab-to-tabbarcontroller

class ModulesTableView: UITableViewController {
    
    var list : [String] = tools.get_Shelf()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        configuration.text = list[indexPath.row]
        cell.contentConfiguration = configuration
        return cell
    }

    /*
     @IBAction func popUpButtonAction(_ sender: NSPopUpButton) {
         tools.setCurrBible(popUpButton.selectedItem!.title)
         makeBookList()
         showCurrVerse(select: currVerse.number > 1)
         mainView.updateStatus(currBible!.fileName + " | " + currBible!.info)
     }
     */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tools.setCurrBible(list[indexPath.row])
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: nil)
    }

}
