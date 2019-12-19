//
//  BibleText.swift
//  Unbound Bible.iOS
//
//  Created by Vladimir Rybant on 19.12.2019.
//  Copyright © 2019 Vladimir Rybant. All rights reserved.
//

import Foundation
import UIKit

class BibleTextView: UITextView {

    func loadChapter() {
        let attributedString = NSMutableAttributedString()
        if let text = bible!.getChapter(activeVerse) {
            if !text.isEmpty {
                for i in 0...text.count-1 {
                    let string = " <l>" + String(i+1) + "</l> " + text[i] + "\n"
                    attributedString.append( parse(string, jtag: true) )
                }
            }
        }
        // // self.baseWritingDirection = bible!.rightToLeft ? .rightToLeft : .leftToRight
        self.textStorage.setAttributedString(attributedString)
    }

}

