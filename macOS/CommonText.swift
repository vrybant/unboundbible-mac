//
//  SuperText.swift
//  Unbound Bible 
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Foundation
import Cocoa

class СommonTextView: CustomTextView {
    
    @IBAction func printDocument(_ sender: NSMenuItem) {
        printView(self)
    }

}

