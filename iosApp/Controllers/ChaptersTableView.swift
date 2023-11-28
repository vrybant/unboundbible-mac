//
//  ChaptersTableViewController.swift
//  iOSApp
//
//  Created by Vladimir Rybant on 22.11.2023.
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import UIKit

class ChaptersTableView: UITableViewController {

    var verse : Verse?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currBible!.chaptersCount(verse!)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        configuration.text = "Chapter \(indexPath.row + 1)"
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        verse?.chapter = indexPath.row + 1
        currVerse = Verse(book: verse!.book, chapter: verse!.chapter, number: 1, count: 1)
        print(currVerse)
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
   }
    
}
