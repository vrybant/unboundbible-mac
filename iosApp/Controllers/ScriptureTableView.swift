//
//  TableViewController.swift
//  iOSApp
//
//  Created by Vladimir Rybant on 02.11.2023.
//

import UIKit

class ScriptureTableView: UITableViewController {
    
    var list = tools.get_Chapter()
    
    @IBOutlet weak var titleButton: UIButton!
    
    //  static let myNotification = Notification.Name("reload")
    
    @IBAction func cancel(segue: UIStoryboardSegue) {
        reloadData()
        saveDefaults()
        let title = currBible!.verseToString(currVerse, cutted: true)
        titleButton.setTitle(title, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notification = Notification.Name(rawValue: "reload")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: notification, object: nil)
    }

    @objc func reloadData() {
        list = tools.get_Chapter()
        self.tableView.reloadData()
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
       
}
