//
//  TableViewController.swift
//  iOSApp
//
//  Created by Vladimir Rybant on 02.11.2023.
//

import UIKit

class ScriptureTableView: UITableViewController {
    
    var list = tools.get_Chapter()
    
    @IBAction func cancel(segue: UIStoryboardSegue) {
        // print("cancelsegue")
    }

    @IBAction func reloadButton(_ sender: Any) {
        list = tools.get_Chapter()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // self.clearsSelectionOnViewWillAppear = false
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
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
