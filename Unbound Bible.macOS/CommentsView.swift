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
    }
    
    override func viewDidAppear() {
        super.viewWillAppear()
        
        self.view.window!.styleMask.remove(NSWindow.StyleMask.fullScreen)
        
        view.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        view.window?.standardWindowButton(.zoomButton       )?.isHidden = true
        
        if shelf.isEmpty { return }
        
        textView.baseWritingDirection = bible!.rightToLeft ? .rightToLeft : .leftToRight
        textView.textStorage?.setAttributedString(copyVerses(options: []))
    }

    
}
