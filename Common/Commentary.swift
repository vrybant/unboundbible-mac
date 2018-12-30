//
//  Commentary.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

class Commentary: Module {
    
    private var z = CommentaryAlias()
    
    override init(atPath: String) {
        super.init(atPath: atPath)
        if format == .mybible { z = mybibleCommentaryAlias }
        if connected && !database!.tableExists(z.commentary) { connected = false }
        
        if connected {
            print("Commentary - \(atPath)")
        }
    }
    
}

var commentaries = Commentaries()

class Commentaries {

}


