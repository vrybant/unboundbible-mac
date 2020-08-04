//
//  WinController.swift
//  Unbound Bible
//
//  Copyright © 2020 Vladimir Rybant. All rights reserved.
//

import Cocoa

var winController = WinController()

class WinController: NSWindowController, NSSearchFieldDelegate {
    
    @IBOutlet weak var windowOutlet: NSWindow!
    @IBOutlet weak var patreonButton: NSButton!
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var searchOptionsButton: NSButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.windowFrameAutosaveName = "AutosaveWindows"
        if !launchedBefore() { setDefaultFrame() }
//      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { alertUpdate() }
        winController = self
    }
    
    func launchedBefore() -> Bool {
        if UserDefaults.standard.bool(forKey: "launchedBefore") { return true }
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        return false
    }

    func setDefaultFrame() {
        let screen = NSScreen.main!.frame.size
        let height = screen.height * 0.7
        let width  = screen.width  * 0.6
        let x = (screen.width  - width ) / 2
        let y = (screen.height + height) / 2 + 20
        let point = CGPoint(x: x, y: y)
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        windowOutlet.setFrame(frame, display: true)
        windowOutlet.setFrameTopLeftPoint(point)
    }
    
    func showUpdate() {
        let tail = languageCode == "ru" ? "ubupdateru.php" : "ubupdate.php"
        let url = "http://vladimirrybant.org/goto/" + tail
        NSWorkspace.shared.open(URL(string: url)!)
    }
    
//  func alertUpdate() {
//      let date = Date()
//      let calendar = Calendar.current
//      let month = calendar.component(.month, from: date)
//      let year  = calendar.component(.year,  from: date)
//
//      if year != 2020 || month != 9 { return }
//
//      let alert = NSAlert()
//      alert.messageText = applicationName
//      alert.informativeText = NSLocalizedString("The beta version has expired.", comment: "") + " " +
//                                NSLocalizedString("Update to the stable version.", comment: "")
//      alert.addButton(withTitle: NSLocalizedString("Update", comment: ""))
//      alert.addButton(withTitle: NSLocalizedString("Later", comment: ""))
//      let choice = alert.runModal()
//      if choice == .alertFirstButtonReturn {
//          showUpdate()
//          exit(0)
//      }
//  }
    
    @IBAction func copyAction(_ sender: NSButton) {
        get_Verses(options: copyOptions).copyToPasteboard()
    }

    @IBAction func searchFieldAction(_ sender: NSSearchField) {
        if shelf.isEmpty { return }
        
        let string = searchField.stringValue.trimmed
        if string.length < 2 { return }
        
        if rigthView.tabView.selectedTab == "dictionaries" {
            rigthView.loadDictionary(key: string)
        } else {
            rigthView.loadSearch(text: string)
        }
    }
    
    @IBAction func patreonPage(_ sender: NSMenuItem) {
        let url = "https://www.patreon.com/vrybant"
        NSWorkspace.shared.open(URL(string: url)!)
        patreonVisited = true
    }
    
    @IBAction func homePage(_ sender: NSMenuItem) {
        let tail = languageCode == "ru" ? "ru" : ""
        let url = "http://vladimirrybant.org" + tail
        NSWorkspace.shared.open(URL(string: url)!)
    }

    @IBAction func downloadsPage(_ sender: NSMenuItem) {
        let tail = languageCode == "ru" ? "ubhelpru.php" : "ubhelp.php"
        let url = "http://vladimirrybant.org/goto/" + tail
        NSWorkspace.shared.open(URL(string: url)!)
    }

    @IBAction func bibleFolder(_ sender: NSMenuItem) {
        NSWorkspace.shared.openFile(dataUrl.path)
    }
    
}
