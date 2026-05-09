//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Cocoa

var preferencesView = PreferencesView()

class PreferencesView: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        preferencesView = self
    }

    override func viewDidAppear() {
        super.viewWillAppear()
    }

}
