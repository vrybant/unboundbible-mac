//
//  SecondViewController.swift
//  Unbound Bible.iOS
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var bookTableViewList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("load")

        view.backgroundColor = .systemBlue
        
//        let attrString = loadCompare_()
//        textView.textStorage.setAttributedString(attrString)
        
        makeBookList() // temp
    }
    
    func makeBookList() {
        if let bible = currBible {
          bookTableViewList = bible.getTitles()
//        bookTableView.reloadData()
//        writingDirection = bible!.rightToLeft ? .rightToLeft : .leftToRight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as UITableViewCell
        cell.textLabel?.text = bookTableViewList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookTableViewList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name = bookTableViewList[indexPath.row]
        if let book = currBible!.bookByName(name) {
            currVerse = Verse(book: book, chapter: 1, number: 1, count: 1)
        }
        print( name )

    }
    
}

