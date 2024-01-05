//
//  TableViewController.swift
//  iOSApp
//
//  Created by Vladimir Rybant on 02.11.2023.
//

import UIKit

class ScriptureTableView: UITableViewController {
    
    var data = tools.get_Chapter()
    
    @IBOutlet weak var titleButton: UIButton!
    
//  static let myNotification = Notification.Name("reload")
    
    @IBAction func cancel(segue: UIStoryboardSegue) {
        reloadData()
        saveDefaults()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notification = Notification.Name(rawValue: "reload")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: notification, object: nil)
        setButton()
    }

    func setButton() {
        let title = currBible!.verseToString(currVerse, cutted: true)
        titleButton.setTitle(title, for: .normal)
    }
    
    @objc func reloadData() {
        data = tools.get_Chapter()
        tableView.reloadData()
        setButton()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        let text = data[indexPath.row]
        configuration.attributedText = parse(text, jtag: true)
        cell.contentConfiguration = configuration
        return cell
    }
       
}
