//
//  FirstViewController.swift
//  Unbound Bible.iOS
//
//  Created by Vladimir Rybant on 19.12.2019.
//  Copyright © 2019 Vladimir Rybant. All rights reserved.
//

import UIKit

var firstView = UIViewController()

class FirstViewController: UIViewController {

    @IBOutlet weak var bibleText: BibleTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bibleText.loadChapter()
    }


}

