//
//  SearchTableView.swift
//  iOSApp
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import UIKit

class SearchTableView: UITableViewController, UISearchResultsUpdating {
        
    let searchController = UISearchController(searchResultsController: nil)

    var list : [String] = tools.get_Shelf()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchController()
    }

    func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        let name = list[indexPath.row]
        configuration.text = name
        cell.contentConfiguration = configuration
        cell.accessoryType = name == currBible!.name ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = list[indexPath.row]
        tools.setCurrBible(name)
        tableView.reloadData()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: nil)
        saveDefaults()
    }

}
