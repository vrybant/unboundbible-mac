//
//  parse.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation

private func replacement(_ string: String) -> String {
    return string
        .replace(  "<i>", with: "[" )
        .replace( "</i>", with: "]" )
        .replace( "<em>", with: "[" )
        .replace("</em>", with: "]" )
        .replace(   "  ", with:  " ")
}

func parse(_ string: String) -> String {
    return replacement(string).removeTags
}

func html(_ string: String, small: Bool = false) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()
    //
    return result
}
