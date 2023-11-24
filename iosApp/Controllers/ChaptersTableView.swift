//
//  ChaptersTableViewController.swift
//  iOSApp
//
//  Created by Vladimir Rybant on 22.11.2023.
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import UIKit

class ChaptersTableView: UITableViewController {

    var chaptersCount = 0
    weak var delegate: UITableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chaptersCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        configuration.text = String(indexPath.row + 1)
        cell.contentConfiguration = configuration
//      cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row + 1)")
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
   }
    
}
