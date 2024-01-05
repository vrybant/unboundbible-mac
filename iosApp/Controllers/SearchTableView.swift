//
//  SearchTableView.swift
//  iOSApp
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import UIKit

class SearchTableView: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var data : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
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

extension SearchTableView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        searchBar.resignFirstResponder() // dismiss the keyboard 
        searchResult(text: searchBar.text!)
        tableView.reloadData()
    }
    
    func searchResult(text: String) {
        if text.count < 2 { return }
        data = tools.get_Search(string: text).strings
        
        if data.count == 0 {
            let message = LocalizedString("You search for % produced no results.")
            let string = "\(message.replace("%", with: text.quoted))"
            print(string)
        }
        
        let status = LocalizedString("verses was found")
        print("\(data.count) \(status)")
    }

}
