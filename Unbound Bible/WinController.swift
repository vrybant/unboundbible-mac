//
//  WinController.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

class WinController: NSWindowController, NSSearchFieldDelegate {
    
    @IBOutlet weak var searchField: NSSearchField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.windowFrameAutosaveName = NSWindow.FrameAutosaveName(rawValue: "AutosaveWindows")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.alertUpdate()
        }
        
        //      self.window?.titlebarAppearsTransparent = true      // Bible Verse Desktop
        //      self.window?.styleMask.insert(.fullSizeContentView)
        //      self.window?.isMovableByWindowBackground = true
    }
    
    func showUpdate() {
        let tail = languageCode() == "ru" ? "ubupdateru.php" : "ubupdate.php"
        let url = "http://vladimirrybant.org/goto/" + tail
        NSWorkspace.shared.open(URL(string: url)!)
    }
    
    func alertUpdate() {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year  = calendar.component(.year,  from: date)

        if year != 2018 || month != 9 { return }

        let alert = NSAlert()
        alert.messageText = applicationName
        alert.informativeText = NSLocalizedString("The beta version has expired.", comment: "") + " " +
                                NSLocalizedString("Update to the stable version.", comment: "")
        alert.addButton(withTitle: NSLocalizedString("Update", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("Later", comment: ""))
        let choice = alert.runModal()
        if choice == .alertFirstButtonReturn {
            showUpdate()
            exit(0)
        }
    }
    
    @IBAction func copyAction(_ sender: NSButton) {
        copyVerses(options: copyOptions).copyToPasteboard()
    }

    @IBAction func searchFieldAction(_ sender: NSSearchField) {
        let string = searchField.stringValue.trimmed
        if string.length > 2 {
            selectTab(at: .search)
            searchText(string: string)
        }
    }
    
    @IBAction func interlinear(_ sender: NSMenuItem) {
        let range = 1...66
        if !range.contains(activeVerse.book) { return }
        let book = bibleHubArray[activeVerse.book]
        let tail = book + "/" + String(activeVerse.chapter) + "-" + String(activeVerse.number) + ".htm"
        let url = "http://biblehub.com/interlinear/" + tail
        NSWorkspace.shared.open(URL(string: url)!)
    }
    
    @IBAction func showHelp(_ sender: NSMenuItem) {
        let tail = languageCode() == "ru" ? "ubhelpru.php" : "ubhelp.php"
        let url = "http://vladimirrybant.org/goto/" + tail
        NSWorkspace.shared.open(URL(string: url)!)
    }

    @IBAction func facebookPage(_ sender: NSMenuItem) {
        let url = "https://www.facebook.com/unbound.bible/"
        NSWorkspace.shared.open(URL(string: url)!)
    }
    
    @IBAction func homePage(_ sender: NSMenuItem) {
        let tail = languageCode() == "ru" ? "ru" : ""
        let url = "http://vladimirrybant.org/" + tail
        NSWorkspace.shared.open(URL(string: url)!)
    }

    @IBAction func bibleFolder(_ sender: NSMenuItem) {
        NSWorkspace.shared.openFile(dataPath)
    }
    
}

