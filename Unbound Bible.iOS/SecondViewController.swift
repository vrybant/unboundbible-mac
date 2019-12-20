//
//  SecondViewController.swift
//  Unbound Bible.iOS
//
//  Created by Vladimir Rybant on 19.12.2019.
//  Copyright © 2019 Vladimir Rybant. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let attrString = loadCompare_() 
        textView.textStorage.setAttributedString(attrString)
    }


}

