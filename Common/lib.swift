//
//  lib.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation
import Cocoa

let applicationName = "Unbound Bible"
let applicationVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
var applicationUpdate = false

let bibleDirectory = "bibles"
let titleDirectory = "titles"

let slash = "/"

let resourcePath = Bundle.main.resourcePath!
let dataPath = NSHomeDirectory() + slash + applicationName

let navyColor = NSColor(red:0.00, green:0.00, blue:0.50, alpha:1.0)

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

var defaultBible: String {
    var result = ""
    switch languageCode {
    case "ru" : result = "rstw.unbound"
    case "uk" : result = "ubio.unbound"
    default   : result = "kjv.unbound"
    }
    return result
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

func getDatabaseList(_ atPath: String) -> [String] {
    let extensions = [".unbound",".bblx",".bbli",".mybible",".SQLite3"]
    return contentsOfDirectory(atPath: atPath)?.filter { $0.hasSuffix(extensions) } ?? []
}

func orthodox(language: String) -> Bool {
    let list = ["ru","uk","bulg"]
    for item in list {
        if language.hasPrefix(item) {
            return true
        }
    }
    return false
}

func copyToClipboard(content: String) {
    let Pasteboard = NSPasteboard.general
    Pasteboard.clearContents()
    Pasteboard.writeObjects([content as NSString])
//  Pasteboard.writeObjects([attrString as NSMutableAttributedString])
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
    if !applicationUpdate && !getDatabaseList(dataPath).isEmpty { return }
    
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
