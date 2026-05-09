//
//  Unbound Bible
//  Copyright © Vladimir Rybant Ministries
//

import Cocoa

class SplitView: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitView.autosaveName = "AutosaveSplit"
    }
    
}
