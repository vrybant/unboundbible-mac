//
//  SearchTableView.swift
//  iOSApp
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import UIKit

class SearchTableView: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var list : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
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

extension SearchTableView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        searchBar.resignFirstResponder() // dismiss the keyboard 
        searchResult(text: searchBar.text!)
        tableView.reloadData()
    }
    
    func searchResult(text: String) {
        if text.count < 2 { return }
        let data = tools.get_Search(string: text).string // !
        
        if data.count == 0 {
            let message = LocalizedString("You search for % produced no results.")
            let string = "\(message.replace("%", with: text.quoted))"
            print(string)
        }

////        list = data
        //searchTextView.textStorage?.setAttributedString(parse(string))
        
        let status = LocalizedString("verses was found")
        print("\(data.count) \(status)")
    }

}
