//
//  TableViewController.swift
//  iOSApp
//
//  Created by Vladimir Rybant on 02.11.2023.
//

import UIKit

class ScriptureTableView: UITableViewController {
    
    var data = tools.get_Chapter(book: currVerse.book, chapter: currVerse.chapter)
    
    @IBOutlet weak var titleButton: UIButton!
    
//  static let myNotification = Notification.Name("reload")
    
    @IBAction func cancel(segue: UIStoryboardSegue) {
        reloadData()
        saveDefaults()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notification = Notification.Name(rawValue: "reload")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: notification, object: nil)
        setButton()
    }

    func setButton() {
        let title = currBible!.verseToString(currVerse, cutted: true)
        titleButton.setTitle(title, for: .normal)
    }
    
    @objc func reloadData() {
        data = tools.get_Chapter(book: currVerse.book, chapter: currVerse.chapter)
        tableView.reloadData()
        setButton()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        3
//    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        "Section \(section + 1)"
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell() as! ScriprureTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScriptureCellID", for: indexPath) as! ScriprureTableViewCell
        let text = data[indexPath.row]
        cell.customLabel.numberOfLines = 0
        cell.customLabel.attributedText = parse(text, jtag: true)
        
//        var content = UIListContentConfiguration.cell()
//        content.attributedText = parse(text, jtag: true)
//        cell.contentConfiguration = content
        
        return cell
    }
 
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
//    }
//    
}
