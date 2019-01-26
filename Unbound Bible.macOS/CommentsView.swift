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
        title = "Commentaries" // NSLocalizedString("Commentaries", comment: "")
    }
    
    @IBAction func CancelButton(_ sender: NSButton) {
        self.view.window?.close()
    }
    
    func setDefaultFrame() {
        let screen = NSScreen.main!.frame.size
        let height = screen.height * 0.6
        let width  = screen.width  * 0.3
        let x = (screen.width  - width ) / 2
        let y = (screen.height + height) / 2 + 20
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let point = CGPoint(x: x, y: y)

        self.view.window?.setFrame(frame, display: true)
        self.view.window?.setFrameTopLeftPoint(point)
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        
//        if !UserDefaults.launchedBefore() {
//            setDefaultFrame()
//        } else {
//            readDefaults()
//        }
        
        readDefaults()
    }
    
    override func viewDidAppear() {
        super.viewWillAppear()

//       self.view.window!.styleMask.remove(NSWindow.StyleMask.fullScreen)
 //       view.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
 //       view.window?.standardWindowButton(.zoomButton       )?.isHidden = true
        
        textView.textStorage?.setAttributedString(loadCommentary())
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
        self.view.window?.setFrame(frame, display: true)
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
