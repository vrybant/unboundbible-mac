//
//  PopupView.swift
//  Unbound Bible.iOS
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import UIKit

//var popupView = UIViewController()

class PopupViewController: UIViewController {

    @IBAction func closeButton(_ sender: UIButton) {
        print("closeButton")
        performSegue(withIdentifier: "unwindSegue2", sender: nil)
//        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemRed
    }

    
}

