//
//  lib.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation

#if os(OSX)
    import Cocoa
    typealias Color = NSColor
    typealias Font = NSFont
#else
    import SwiftUI
    typealias Color = UIColor
    typealias Font = UIFont
#endif

var darkAppearance: Bool = false
let resourceUrl = Bundle.main.resourceURL!

#if os(OSX)
    let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
    let dataUrl = homeUrl.appendingPathComponent(applicationName)
#else
    let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//  let dataUrl = documentPath.appendingPathComponent(applicationName)
    let dataUrl = resourceUrl.appendingPathComponent(bibleDirectory)
#endif

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
#if os(OSX)
    NSLocale.autoupdatingCurrent.languageCode ?? "en"
#else
    NSLocale.autoupdatingCurrent.language.languageCode?.identifier ?? "en"
#endif
}

var russianSpeaking: Bool {
    ["ru","uk"].contains(languageCode)
}

func printlocal() {
#if os(OSX)
    let locale = NSLocale.autoupdatingCurrent
    let code = locale.languageCode
    let enlocale = NSLocale(localeIdentifier: "en_US")
    let identifier = locale.identifier
    let name = enlocale.displayName(forKey: NSLocale.Key.identifier, value: identifier)
    let language = enlocale.localizedString(forLanguageCode: code!)
    print(code!, language!, identifier, name!)
#endif
}

func printlist(_ string: String) {
  print(string.replace("\0", with: " "))
}

func LocalizedString(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
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

func contentsOfDirectory(url: URL) -> [String]? {
    if !FileManager.default.fileExists(atPath: url.path) { return nil }
    var result = [String]()
    if let files = try? FileManager.default.contentsOfDirectory(atPath: url.path) {
        for file in files {
            let path = url.appendingPathComponent(file).path
            result.append(path)
        }
    }
    return !result.isEmpty ? result : nil
}

#if os(OSX)
func copyToPasteboard(content: NSMutableAttributedString) {
    let Pasteboard = NSPasteboard.general
    Pasteboard.clearContents()
    Pasteboard.writeObjects([content])
}
#endif

func + (left: NSMutableAttributedString, right: NSMutableAttributedString) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

func getRightToLeft(language: String) -> Bool {
    language.hasPrefix("he") || language.hasPrefix("ara") || language.hasPrefix("fa")
}

#if os(OSX)
func copyDefaultsFiles() {
    if !FileManager.default.fileExists(atPath: dataUrl.path)  {
        try? FileManager.default.createDirectory(at: dataUrl, withIntermediateDirectories: false, attributes: nil)
    }

    let empty = unboundBiblesList.isEmpty
    if !applicationUpdate && !empty { return }

    let atDirectory = resourceUrl.appendingPathComponent(bibleDirectory)
    if let items = try? FileManager.default.contentsOfDirectory(atPath: atDirectory.path) {
        for item in items {
            let atPath = atDirectory.appendingPathComponent(item).path
            let toUrl = dataUrl.appendingPathComponent(item)
            let toPath = dataUrl.appendingPathComponent(item).path

            if !empty && !FileManager.default.fileExists(atPath: toPath)  { continue }
            
            try? FileManager.default.removeItem(at: toUrl)
            try? FileManager.default.copyItem(atPath: atPath, toPath: toPath)
        }
    }
}
#endif
