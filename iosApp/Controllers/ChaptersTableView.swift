//
//  ChaptersTableViewController.swift
//  iOSApp
//
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
        var content = UIListContentConfiguration.cell()
        let chapter = "Глава" // "Chapter"
        content.text = "\(chapter) \(indexPath.row + 1)"
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        verse!.chapter = indexPath.row + 1
        currVerse = verse!
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
   }
    
}
