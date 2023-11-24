//
//  BooksTableViewController.swift
//  iOSApp
//
//  Created by Vladimir Rybant on 23.11.2023.
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import UIKit

class BooksTableView: UITableViewController {

    let titles = currBible!.getTitles()
    var currRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // self.clearsSelectionOnViewWillAppear = false
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    @IBAction func doneButton(_ sender: Any) {
        print("doneButton")
        self.dismiss(animated: true)
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        configuration.text = titles[indexPath.row]
        cell.contentConfiguration = configuration
        //cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currRow = indexPath.row
        print(currRow)
        
//        DispatchQueue.main.async {
//            self.dismiss(animated: true)
//            }
        
        self.performSegue(withIdentifier: "GoToChapters", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToChapters" {
            let book = currRow + 1
            let verse = Verse(book: book, chapter: 1, number: 1, count: 1)

            let destinationView = segue.destination as! ChaptersTableView
            destinationView.chaptersCount = currBible!.chaptersCount(verse)
            destinationView.delegate = self
        }
    }

}
