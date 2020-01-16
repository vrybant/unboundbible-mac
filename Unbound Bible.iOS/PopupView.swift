//
//  PopupView.swift
//  Unbound Bible.iOS
//
//  Created by Vladimir Rybant on 03.01.2020.
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import UIKit

var popupView = UIViewController()

class PopupViewController: UIViewController {

    @IBAction func closeButton(_ sender: UIButton) {
        print("dismiss")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemRed
    }

    
}

