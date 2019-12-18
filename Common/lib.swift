//
//  lib.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation

#if os(OSX)
    import Cocoa
    typealias Color = NSColor
    typealias Font = NSFont
#else
    import UIKit
    typealias Color = UIColor
    typealias Font = UIFont
#endif

var darkAppearance: Bool = false

let slash = "/"
let resourcePath = Bundle.main.resourcePath!
let dataPath = NSHomeDirectory() + slash + applicationName

//let navyColor = Color(red:0.00, green:0.00, blue:0.50, alpha:1.0)

enum Errors : Error {
    case someError
    case someOtherError
}

//  var darkInterfaceStyle: Bool {
//      let style = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
//      return style == "Dark"
//  }

var languageCode: String {
    return NSLocale.autoupdatingCurrent.languageCode ?? "en"
}

func listToXml(list: [String]) -> String {
    var result = ""
    for item in list { result += item }
    return result
}

func xmlToList(string: String) -> [String] {
    var result: [String] = []
    var temp = ""
    
    for c in string {
        if c == "<" {
            result.append(temp)
            temp = ""
        }
        temp.append(c)
        
        if c == ">" {
            result.append(temp)
            temp = ""
        }
    }
    if !temp.isEmpty {
        result.append(temp)
    }
    return result
}

func contentsOfDirectory(atPath: String) -> [String]? {
    if !FileManager.default.fileExists(atPath: atPath) { return nil }
    var result = [String]()
    if let files = try? FileManager.default.contentsOfDirectory(atPath: atPath) {
        for file in files {
            result.append(atPath + slash + file)
        }
    }
    return !result.isEmpty ? result : nil
}

func cyrillic(language: String) -> Bool {
    let list = ["ru","uk","bg"]
    for item in list {
        if language.hasPrefix(item) {
            return true
        }
    }
    return false
}

func copyToClipboard(content: String) {
    #if os(OSX)
        let Pasteboard = NSPasteboard.general
        Pasteboard.clearContents()
        Pasteboard.writeObjects([content as NSString])
    //  Pasteboard.writeObjects([attrString as NSMutableAttributedString])
    #endif
}

func + (left: NSMutableAttributedString, right: NSMutableAttributedString) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

func getRightToLeft(language: String) -> Bool {
    return language.hasPrefix("he") || language.hasPrefix("ara") || language.hasPrefix("fa")
}

func copyDefaultsFiles() {
    if !FileManager.default.fileExists(atPath: dataPath)  {
        try? FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
    }
    if !applicationUpdate && !databaseList().isEmpty { return }
    
    let atDirectory = resourcePath + slash + bibleDirectory
    if let items = try? FileManager.default.contentsOfDirectory(atPath: atDirectory) {
        for item in items {
            let atPath = atDirectory + slash + item
            let toPath = dataPath + slash + item
            try? FileManager.default.removeItem(at: URL(fileURLWithPath: toPath))
            try? FileManager.default.copyItem(atPath: atPath, toPath: toPath)
        }
    }
}
