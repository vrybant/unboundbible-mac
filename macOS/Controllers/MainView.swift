//
//  ViewController.swift
//  Unbound Bible
//
//  Copyright © 2021 Vladimir Rybant. All rights reserved.
//

import Cocoa

var mainView = MainView()

class MainView: NSViewController, NSWindowDelegate {

    private var popoverView = PopoverView.instance()
    private var popover = NSPopover()
    private var noteURL : URL?
    private var statuses = [String: String]()

    @IBOutlet weak var statusBar: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = self
        popover.contentViewController = popoverView
        popover.behavior = .transient
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.delegate = self
    }
    
    override func viewDidAppear() {
        self.view.window?.delegate = self
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        if closeDocument() {
            NSApplication.shared.terminate(self)
            return true
        } else {
            return false
        }
    }
    
    func showPopover(_ attrString: NSAttributedString, sender: NSTextView) {
        let firstRect = sender.firstRect(forCharacterRange: sender.selectedRange, actualRange: nil)
        let converted = self.view.window?.convertFromScreen(firstRect)
        let rect = NSRect(x: converted!.minX, y: converted!.minY , width: 1, height: 1)
        popover.show(relativeTo: rect, of: self.view, preferredEdge: .minY)
        popoverView!.setAttrString(attrString)
    }
    
    func refreshStatus() {
        let tab = rigthView.tabView.selectedTab!
        statusBar.title = statuses[tab] ?? ""
    }
    
    func updateStatus(_ status: String) {
        let tab = rigthView.tabView.selectedTab!
        statuses.updateValue(status, forKey: tab)
        refreshStatus()
    }
    
    func rebuildRecentList() {
        if noteURL == nil { return }
        let max = 10
        var list = [URL]()
        list.append(noteURL!)
        for item in recentList {
            if item != noteURL!, list.count < max {
                list.append(item)
            }
        }
        recentList = list
        appDelegate.createRecentMenu()
    }
    
    func openDocument(url: URL?) {
        if url == nil { return }
        do {
            try rigthView.notesTextView.loadFromFile(url: url!)
            selectTab("notes")
            noteURL = url
            rebuildRecentList()
            appDelegate.saveMenuItem.title = LocalizedString("Save")
            
            let s = LocalizedString("Document Name")
            let status = s + ": " + noteURL!.lastPathComponent
            updateStatus(status)
        } catch {
            let alert = NSAlert()
            alert.alertStyle = .critical
            let message = LocalizedString("The document % could not be opened.")
            alert.messageText = message.replace("%", with: url!.lastPathComponent.quoted)
            alert.runModal()
        }
    }
    
    func saveDocument(url: URL?) {
        if url == nil { return }
        do {
            try rigthView.notesTextView.saveToFile(url: url!)
            noteURL = url
            rebuildRecentList()
            appDelegate.saveMenuItem.title = LocalizedString("Save")
        } catch {
            let alert = NSAlert()
            alert.alertStyle = NSAlert.Style.critical
            alert.messageText = LocalizedString("Failed to save document.")
            alert.informativeText = LocalizedString("Permission denied.")
            alert.runModal()
        }
    }
    
    func closeDocument() -> Bool {
        saveDocument(url: noteURL)
        var result = true
        if noteURL == nil && !rigthView.notesTextView.string.isEmpty {
            selectTab("notes")
            let alert = NSAlert()
            alert.messageText = LocalizedString("Do you want to save the changes?")
            alert.informativeText = LocalizedString("Your changes will be lost if you don't save them.")
            alert.addButton(withTitle: LocalizedString("Save"))
            alert.addButton(withTitle: LocalizedString("Cancel"))
            alert.addButton(withTitle: LocalizedString("Don't Save"))
            let choice = alert.runModal()
            switch choice {
            case .alertFirstButtonReturn: // Save
                saveDocumentAction(self)
                if noteURL == nil { result = false }
            case .alertSecondButtonReturn: // Cancel
                result = false
            default: break
            }
        }
        if result {
            rigthView.notesTextView.clean()
            noteURL = nil
        }
        return result
    }
    
    @IBAction func newDocument(_ sender: NSMenuItem) {
        if !mainView.closeDocument() { return }
        selectTab("notes")
        appDelegate.saveMenuItem.title = LocalizedString("Save…")
    }
    
    @IBAction func openDocumentAction(_ sender: NSMenuItem) {
        let dialog = NSOpenPanel()
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = true
        dialog.canCreateDirectories    = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes        = ["rtf"]
        
        if dialog.runModal() == .OK {
            if mainView.closeDocument() {
                openDocument(url: dialog.url)
            }
        }
    }
    
    @IBAction func saveDocumentAction(_ sender: Any) {
        if noteURL != nil { return }
        selectTab("notes")

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
        rigthView.loadChapter()
    }
    
    @IBAction func showPreferences(_ sender: Any) {
        let alert = NSAlert()
        alert.messageText = LocalizedString("Preferences")
        let displayFont = defaultFont.displayName! + " " + String(describing: defaultFont.pointSize)
        alert.informativeText = LocalizedString("Font") + ": " + displayFont
        alert.addButton(withTitle: LocalizedString("OK"))
        alert.addButton(withTitle: LocalizedString("Change Font"))
        let choice = alert.runModal()
        if choice == .alertFirstButtonReturn { return } // OK
    
        let fontManager = NSFontManager.shared
        fontManager.target = self
        fontManager.action = #selector(self.changeCustomFont)
        let fontPanel: NSFontPanel? = fontManager.fontPanel(true)
        fontPanel?.setPanelFont(defaultFont, isMultiple: false)
        fontPanel?.makeKeyAndOrderFront(sender)
    }

    func welcome() {
        if !applicationUpdate { return }
        if !russianSpeaking { return }
//      let storyboard = NSStoryboard(name: "WelcomeView"", bundle: Bundle.main)
//      if let welcomeView = storyboard.instantiateController(withIdentifier: "WelcomeView") as? WelcomeView {
//          presentAsModalWindow(welcomeView)
//    }
    }
    
}

