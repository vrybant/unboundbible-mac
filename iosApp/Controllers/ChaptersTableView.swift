//
//  ChaptersTableViewController.swift
//  iOSApp
//
//  Created by Vladimir Rybant on 22.11.2023.
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import UIKit

class ChaptersTableView: UITableViewController {

    var book = 1

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currBible!.chaptersCount(Verse(book: book, chapter: 1, number: 1, count: 1))
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        configuration.text = "Chapter \(indexPath.row + 1)"
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chapter = indexPath.row + 1
        currVerse = Verse(book: book, chapter: chapter, number: 1, count: 1)
        print(currVerse)
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
   }
    
}
