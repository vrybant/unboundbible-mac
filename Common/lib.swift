//
//  lib.swift
//  Unbound Bible
//
//  Copyright © 2018 Vladimir Rybant. All rights reserved.
//

import Foundation
import Cocoa

let applicationName = "Unbound Bible"

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

func fileExists(_ atPath: String) -> Bool {
    let fileManager = FileManager.default
    return fileManager.fileExists(atPath: atPath)
}

func getFileList(_ atPath: String) -> [String] {
    var result = [String]()
    do {
        let files = try FileManager.default.contentsOfDirectory(atPath: atPath)
        for file in files {
            result.append(atPath + slash + file)
        }
    } catch {
        // failed
    }
    return result
}

func getDatabaseList(_ atPath: String) -> [String] {
    let extensions = [".unbound",".bblx",".bbli",".mybible",".SQLite3"]
    return getFileList(atPath).filter { $0.hasSuffix(extensions) }
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

//    func getFileListWithExt(_ path: String, ext: String) -> [String] {
//     return getFileList(path).filter{ $0.hasSuffix(".\(ext)") }
//    }

//    func StringByDeletingPathExtension(_ path: String) -> String {
//        return (NSURL(fileURLWithPath: path).deletingPathExtension?.lastPathComponent)! as String
//    }

//    func readFromFile(_ path: String) -> String {
//        var text : String
//        do {
//            try text = NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
//        }
//        catch {
//            return ""
//        }
//        return text
//    }

//    func writeToFile(_ path: String, value: String) -> Bool {
//        do {
//            try value.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
//        } catch {
//            return false
//        }
//        return true
//    }

//    func showClipboardContent(_ sender: NSButton) {
//        let pb = NSPasteboard.general
//        for item in pb.pasteboardItems ?? [] {
//            if let str = item.string(forType: NSPasteboard.PasteboardType.string) {
//                print(str)
//            }
//        }
//    }

func copyToClipboard(content: String) {
    let Pasteboard = NSPasteboard.general
    Pasteboard.clearContents()
    Pasteboard.writeObjects([content as NSString])
//  Pasteboard.writeObjects([attrString as NSMutableAttributedString])
}

func + (left: NSMutableAttributedString, right: NSMutableAttributedString) -> NSMutableAttributedString
{
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

func getRightToLeft(language: String) -> Bool {
    return language.hasPrefix("he") || language.hasPrefix("ara") || language.hasPrefix("fa")
}

func createDirectory(atPath: String) {
    do {
        try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
    } catch {
        // failed
    }
}

func copyDefaultsFiles() {
    if FileManager.default.fileExists(atPath: dataPath) { return }
    createDirectory(atPath: dataPath)
    
    do {
        let atDirectory = resourcePath + slash + bibleDirectory
        let items = try FileManager.default.contentsOfDirectory(atPath: atDirectory)
        for item in items {
            let atPath = atDirectory + slash + item
            let toPath = dataPath + slash + item
            do {
                try FileManager.default.copyItem(atPath: atPath, toPath: toPath)
            } catch {
                // failed
            }
        }
    } catch {
        // failed
    }
}
