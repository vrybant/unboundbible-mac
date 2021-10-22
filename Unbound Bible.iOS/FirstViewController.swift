//
//  FirstViewController.swift
//  Unbound Bible.iOS
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import UIKit

var firstView = UIViewController()

class FirstViewController: UIViewController {

    @IBAction func bookAction(_ sender: UIButton) {
        print("ok")
    }
    
    @IBOutlet weak var bibleText: BibleTextView!
    
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

