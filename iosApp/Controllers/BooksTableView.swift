//
//  iOSApp
//
//  Copyright © Vladimir Rybant. All rights reserved.
//

import UIKit

class BooksTableView: UITableViewController {
    
    private let titles = currBible!.getTitles()
    private var book : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false

        if let index = currBible!.idxByNum(currVerse.book) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        }
    }
    
    @IBAction func doneButton(_ sender: Any) {
        print("doneButton")
        self.dismiss(animated: true)
    }
        
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = UIListContentConfiguration.cell()
        content.text = titles[indexPath.row]
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .default
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = titles[indexPath.row]
        book = currBible!.bookByName(name)
        performSegue(withIdentifier: "GoToChapters", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToChapters" {
            let destinationView = segue.destination as! ChaptersTableView
            destinationView.book = book
        }
    }
    
}
