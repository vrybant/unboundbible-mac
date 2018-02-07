//
//  ViewController.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

var mainView = MainView()

class MainView: NSViewController, NSWindowDelegate {

    private var noteURL : URL?
    private var statuses : [String] = ["","","",""]
    
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var statusBar: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = self
    }
    
    override func viewDidAppear() {
        self.view.window?.delegate = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.delegate = self
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        if closeDocument() {
            rigthView.notesTextView.clean() // предотвращает от повторного вызова closeDocument()
            NSApplication.shared.terminate(self)
            return true
        } else {
            return false
        }
    }
    
    func refreshStatus() {
        let identifier = rigthView.tabView.selectedTabViewItem?.identifier as! String
        switch identifier {
        case "bible"   : statusBar.title = statuses[0]
        case "search"  : statusBar.title = statuses[1]
        case "compare" : statusBar.title = statuses[2]
        case "notes"   : statusBar.title = statuses[3]
        default : break
        }
    }
    
    func updateStatus(_ status: String) {
        let identifier = rigthView.tabView.selectedTabViewItem?.identifier as! String
        switch identifier {
        case "bible"   : statuses[0] = status
        case "search"  : statuses[1] = status
        case "compare" : statuses[2] = status
        case "notes"   : statuses[3] = status
        default : break
        }
        refreshStatus()
    }
    
    func saveDocument(url: URL?) {
        if url == nil { return }
        do {
            try rigthView.notesTextView.saveToFile(url: url!)
            noteURL = url
            appDelegate.saveMenuItem.title = NSLocalizedString("Save", comment: "")
        } catch {
            let alert = NSAlert()
            alert.alertStyle = NSAlert.Style.critical
            alert.messageText = NSLocalizedString("Failed to save document.", comment: "")
            alert.informativeText = NSLocalizedString("Permission denied.", comment: "")
            alert.runModal()
        }
    }
    
    func closeDocument() -> Bool {
        saveDocument(url: noteURL)
        if noteURL != nil { return true }
        if rigthView.notesTextView.string.isEmpty { return true }
        
        selectTab(at: .notes)
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Do you want to save the changes?", comment: "")
        alert.informativeText = NSLocalizedString("Your changes will be lost if you don't save them.", comment: "")
        alert.addButton(withTitle: NSLocalizedString("Save", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("Cancel", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("Don't Save", comment: ""))
        let choice = alert.runModal()
        
        switch choice {
        case .alertFirstButtonReturn: // Save
            saveDocumentAs(self)
            if noteURL != nil { return true }
        case .alertThirdButtonReturn: // Don't Save
            return true
        default: break // Cancel
        }
        return false
    }
    
    @IBAction func newDocument(_ sender: NSMenuItem) {
        if !mainView.closeDocument() { return }
        rigthView.notesTextView.clean()
        selectTab(at: .notes)
        noteURL = nil
        appDelegate.saveMenuItem.title = NSLocalizedString("Save…", comment: "")
    }
    
    @IBAction func openDocument(_ sender: NSMenuItem) {
        if !mainView.closeDocument() { return }
        let dialog = NSOpenPanel()

        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = true
        dialog.canCreateDirectories    = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes        = ["rtf"]
        
        if dialog.runModal() != .OK { return }
        
        if let url = dialog.url {
            do {
                try rigthView.notesTextView.loadFromFile(url: url)
                selectTab(at: .notes)
                noteURL = url
                appDelegate.saveMenuItem.title = NSLocalizedString("Save", comment: "")
                
                let s = NSLocalizedString("Document Name", comment: "")
                let status = s + ": " + noteURL!.lastPathComponent
                updateStatus(status)
            } catch {
                let alert = NSAlert()
                alert.alertStyle = .critical
                let message = NSLocalizedString("The document % could not be opened.", comment: "")
                alert.messageText = message.replace("%", url.lastPathComponent.quoted)
                alert.runModal()
            }
        }
    }
    
    @IBAction func saveDocumentAs(_ sender: Any) {
        if noteURL != nil { return }
        selectTab(at: .notes)

        let dialog = NSSavePanel()
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles     = false
        dialog.canCreateDirectories = true
        dialog.allowedFileTypes     = ["rtf"]
        if dialog.runModal() == .OK {
            saveDocument(url: dialog.url)
        }
    }
 
    @objc func changeCustomFont(_ sender: Any?) {
        defaultFont = NSFontManager.shared.convert(defaultFont)
        loadChapter()
        selectTab(at: .bible)
        print(defaultFont.fontName)
        print(defaultFont.pointSize)
    }
    
    @IBAction func showPreferences(_ sender: Any) {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Preferences", comment: "")
        let displayFont = defaultFont.displayName! + " " + String(describing: defaultFont.pointSize)
        alert.informativeText = NSLocalizedString("Font", comment: "") + ": " + displayFont
        alert.addButton(withTitle: NSLocalizedString("OK", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("Change Font", comment: ""))
        let choice = alert.runModal()
        if choice == .alertFirstButtonReturn { return } // OK
    
        let fontManager = NSFontManager.shared
        fontManager.target = self
        fontManager.action = #selector(self.changeCustomFont)
        let fontPanel: NSFontPanel? = fontManager.fontPanel(true)
        fontPanel?.setPanelFont(defaultFont, isMultiple: false)
        fontPanel?.makeKeyAndOrderFront(sender)
    }
}

