//
//  SearchView.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Cocoa

class SearchView: NSViewController {
    
    @IBOutlet weak var caseSensitiveButton: NSButton!
    @IBOutlet weak var phraseButton: NSButton!
    @IBOutlet weak var wholeWordsButton: NSButton!
    
    @IBOutlet weak var bibleButton: NSButton!
    @IBOutlet weak var oldTestamentButton: NSButton!
    @IBOutlet weak var newTestamentButton: NSButton!
    @IBOutlet weak var gospelsButton: NSButton!
    @IBOutlet weak var epistlesButton: NSButton!
    @IBOutlet weak var openedBookButton: NSButton!
    
    @IBAction func checkButtonAction(_ sender: NSButton) {
        searchOption = []
        
        if wholeWordsButton.state.rawValue    == 1 { searchOption.insert(.wholeWords)    }
        if caseSensitiveButton.state.rawValue == 1 { searchOption.insert(.caseSensitive) }
    }
    
    @IBAction func radioButtonAction(_ sender: NSButton) {
        if bibleButton.state.rawValue        == 1 { rangeOption = .bible        }
        if oldTestamentButton.state.rawValue == 1 { rangeOption = .oldTestament }
        if newTestamentButton.state.rawValue == 1 { rangeOption = .newTestament }
        if gospelsButton.state.rawValue      == 1 { rangeOption = .gospels      }
        if epistlesButton.state.rawValue     == 1 { rangeOption = .epistles     }
        if openedBookButton.state.rawValue   == 1 { rangeOption = .openedBook   }
    }

    override func viewWillAppear() {
        wholeWordsButton.state    = NSControl.StateValue(rawValue: searchOption.contains(.wholeWords)    ? 1 : 0)
        caseSensitiveButton.state = NSControl.StateValue(rawValue: searchOption.contains(.caseSensitive) ? 1 : 0)

        bibleButton.state         = NSControl.StateValue(rawValue: rangeOption == .bible        ? 1 : 0)
        oldTestamentButton.state  = NSControl.StateValue(rawValue: rangeOption == .oldTestament ? 1 : 0)
        newTestamentButton.state  = NSControl.StateValue(rawValue: rangeOption == .newTestament ? 1 : 0)
        gospelsButton.state       = NSControl.StateValue(rawValue: rangeOption == .gospels      ? 1 : 0)
        epistlesButton.state      = NSControl.StateValue(rawValue: rangeOption == .epistles     ? 1 : 0)
        openedBookButton.state    = NSControl.StateValue(rawValue: rangeOption == .openedBook   ? 1 : 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

