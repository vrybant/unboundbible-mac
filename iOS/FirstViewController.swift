//
//  FirstViewController.swift
//  Unbound Bible.iOS
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import UIKit

//var firstView = UIViewController()

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var content = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func bookAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SegueID", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SegueID" else { return }
        
        if let secondVC = segue.destination as? SecondViewController {
            secondVC.completion = { [weak self] name in
                guard let self = self else { return }
                if let book = currBible!.bookByName(name) {
                    currVerse = Verse(book: book, chapter: 1, number: 1, count: 1)
                    self.loadChapter()
                    self.tableView.reloadData()
                    print("name = \(name)")
                }
            }
            secondVC.modalPresentationStyle = .fullScreen
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      view.backgroundColor = .systemRed
    }
    
    func loadChapter() {
        content = tools.get_Chapter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tools.bibles.isEmpty { return }
        loadChapter()
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell-ID", for: indexPath) as UITableViewCell
        cell.textLabel?.text = content[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
}
