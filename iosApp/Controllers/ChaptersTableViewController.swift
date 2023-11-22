//
//  ChaptersTableViewController.swift
//  iOSApp
//
//  Created by Vladimir Rybant on 22.11.2023.
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import UIKit

class ChaptersTableViewController: UITableViewController {

    let titles = currBible!.getTitles()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        configuration.text = titles[indexPath.row]
        cell.contentConfiguration = configuration
        return cell
    }

}
