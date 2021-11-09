//
//  FirstViewController.swift
//  Unbound Bible.iOS
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import UIKit

//var firstView = UIViewController()

class FirstViewController: UIViewController {

    @IBAction func bookAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SegueID", sender: nil)
    }
    
    @IBOutlet weak var bibleText: BibleTextView!
    
    var testtext : String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SegueID" else { return }
        
        if let secondVC = segue.destination as? SecondViewController {
            secondVC.completion = { [weak self] text in
                guard let self = self else { return }
                self.testtext = text
                print("name = \(text)")
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      view.backgroundColor = .systemRed
    }
    
    func loadChapter() {
        let text = tools.get_Chapter()
        let attrString = parse(text, jtag: true)
//      bibleText.baseWritingDirection = currBible!.rightToLeft ? .rightToLeft : .leftToRight
        bibleText.textStorage.setAttributedString(attrString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tools.bibles.isEmpty { return }
        loadChapter()
    }
 
}
