//
//  ViewController.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Cocoa

var mainView = MainView()

class MainView: NSViewController, NSWindowDelegate {

    var notesURL: URL?
    
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
    
    func updateStatus(_ title: String) {
        statusBar.title = title
    }
    
    func saveDocument() {
        if !rigthView.notesTextView.modified { return }
        if notesURL == nil { return }
        do {
            try rigthView.notesTextView.saveToFile(url: notesURL!)
            rigthView.notesTextView.modified = false
        } catch {
            // something went wrong
        }
    }
    
    func closeDocument() -> Bool {
        saveDocument()
        if notesURL != nil { return true }
        if rigthView.notesTextView.string == "" { return true }
        
        selectTab(at: .notes)
        let alert = NSAlert()
        alert.messageText = "Do you want to save the changes?"
        alert.informativeText = "Your changes will be lost if you don't save them."
        alert.addButton(withTitle: "Save…")
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "Don't Save")
        let choice = alert.runModal()
        
        switch choice {
        case NSApplication.ModalResponse.alertFirstButtonReturn: // Save…
            saveDocumentAs(self)
            if notesURL != nil { return true }
        case NSApplication.ModalResponse.alertThirdButtonReturn: // Don't Save
            return true
        default: break // Cancel
        }
        return false
    }
    
    @IBAction func newDocument(_ sender: NSMenuItem) {
        if !mainView.closeDocument() { return }
        rigthView.notesTextView.clean()
        selectTab(at: .notes)
        notesURL = nil
        appDelegate.saveMenuItem.title = "Save.."
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
        
        /*
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            if let url = dialog.url {
                do {
                    try rigthView.notesTextView.loadFromFile(url: url)
                    selectTab(at: .notes)
                    notesURL = url
                    appDelegate.saveMenuItem.title = "Save"
                } catch {
                    let alert = NSAlert()
                    alert.messageText = "The document \"\(url.lastPathComponent)\" could not be opened."
                    alert.runModal()
                }
            }
        }
        */
        
    }
    
    @IBAction func saveDocumentAs(_ sender: Any) {
        if notesURL != nil { return }
        
        selectTab(at: .notes)
        let dialog = NSSavePanel()
        
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles     = false
        dialog.canCreateDirectories = true
        dialog.allowedFileTypes     = ["rtf"]
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            if let url = dialog.url {
                do {
                    try rigthView.notesTextView.saveToFile(url: url)
                    notesURL = url
                    appDelegate.saveMenuItem.title = "Save"
                } catch {
                    let alert = NSAlert()
                    alert.messageText = "Failed to save document"
                    alert.informativeText = "Permission denied"
                    alert.runModal()
                }
            }
        }
    }
    
    @IBAction func printDocument(_ sender: Any) {
        let identifier = rigthView.tabView.selectedTabViewItem?.identifier as! String
        switch identifier {
        case "bible"   : rigthView.bibleTextView.printView(self)
        case "search"  : rigthView.searchTextView.printView(self)
        case "compare" : rigthView.compareTextView.printView(self)
        case "notes"   : rigthView.notesTextView.printView(self)
        default : break
        }
    }

}

