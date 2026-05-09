//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation
import Cocoa

class СommonTextView: CustomTextView {
    
    @IBAction func printDocument(_ sender: NSMenuItem) {
        printView(self)
    }

}

