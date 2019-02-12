//
//  CommentView.swift
//  Unbound Bible
//
//  Copyright © 2019 Vladimir Rybant. All rights reserved.
//

import Cocoa

var commentsView = CommentsView()

class CommentsView: NSViewController {

    @IBOutlet weak var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsView = self
        title = NSLocalizedString("Commentaries", comment: "")
    }
    
    @IBAction func showHelp(_ sender: NSMenuItem) {
        mainView.showHelp(sender)
    }
    
    func appearedBefore() -> Bool {
        if UserDefaults.standard.bool(forKey: "cmAppearedBefore") { return true }
        UserDefaults.standard.set(true, forKey: "cmAppearedBefore")
        return false
    }
    
    func setDefaultFrame() {
        let screen = NSScreen.main!.frame.size
        let height = screen.height * 0.6
        let width  = screen.width  * 0.3
        let x = (screen.width  - width ) / 2
        let y = (screen.height + height) / 2 + 20
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let point = CGPoint(x: x, y: y)

        view.window?.setFrame(frame, display: true)
        view.window?.setFrameTopLeftPoint(point)
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.minSize = NSSize(width: 250, height: 250)

        if !appearedBefore() {
            setDefaultFrame()
        } else {
            readDefaults()
        }
    }
    
    func showCommentary() {
        if !commentaries.items.isEmpty {
            textView.textStorage?.setAttributedString(loadCommentary())
        } else {
            let s = "\n У вас не установленно ни одного модуля комментариев."
                  + "\n\n Для дополнительной информации выберите в строке меню «Справка» > «Справка Unbound Bible»."
            let msg = s.mutable(attributes: defaultAttributes)
            textView.textStorage?.setAttributedString(msg)
        }
    }
    
    override func viewDidAppear() {
        super.viewWillAppear()

        view.window?.standardWindowButton(.miniaturizeButton)?.isEnabled = false
        view.window?.standardWindowButton(.zoomButton       )?.isEnabled = false
        
        showCommentary()
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        saveDefaults()
    }
    
    func readDefaults() {
        let defaults = UserDefaults.standard
        
        let x = defaults.cgfloat(forKey: "cmX")
        let y = defaults.cgfloat(forKey: "cmY")
        let height = defaults.cgfloat(forKey: "cmHeight")
        let width  = defaults.cgfloat(forKey: "cmWidth" )
        
        let frame = NSRect(x: x, y: y, width: width, height: height)
        view.window?.setFrame(frame, display: true)
    }
    
    func saveDefaults() {
        let defaults = UserDefaults.standard
        let frame = self.view.window?.frame

        defaults.set(frame!.minX, forKey: "cmX")
        defaults.set(frame!.minY, forKey: "cmY")
        defaults.set(frame!.size.height, forKey: "cmHeight")
        defaults.set(frame!.size.width,  forKey: "cmWidth" )
    }
    
}
