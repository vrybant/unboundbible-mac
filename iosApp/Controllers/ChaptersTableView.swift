//
//  iOSApp
//
//  Copyright © Vladimir Rybant. All rights reserved.
//

import UIKit

class ChaptersTableView: UITableViewController {
    
    private var verse : Verse?
    var book : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        verse = Verse(book: book!, chapter: 1, number: 1, count: 1)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currBible!.chaptersCount(book: verse!.book)
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
