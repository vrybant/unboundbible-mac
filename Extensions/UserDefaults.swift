//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

extension UserDefaults {
    
    func cgfloat(forKey defaultName: String) -> CGFloat {
        CGFloat(self.float(forKey: defaultName))
    }
    
    func verse(forKey defaultName: String) -> Verse? {
        guard let jsonData = self.data(forKey: defaultName) else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Verse.self, from: jsonData)
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    func set(_ value: Verse, forKey defaultName: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            self.set(encoded, forKey: defaultName)
        }
    }
    
    func rowDataList(forKey defaultName: String) -> [RowData] {
        guard let jsonData = self.data(forKey: defaultName) else {
            return []
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([RowData].self, from: jsonData)
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
    
    func set(_ value: [RowData], forKey defaultName: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            self.set(encoded, forKey: defaultName)
        }
    }
    
    func copyOption(forKey defaultName: String) -> CopyOptions {
        CopyOptions(rawValue: self.integer(forKey: defaultName))
    }
    
    func set(_ value: any OptionSet, forKey defaultName: String) {
        self.set(value.rawValue, forKey: defaultName)
    }

    #if COCOA
    func font(forKey defaultName: String, forSize defaultSize: String) -> Font? {
        if let name = self.string(forKey: defaultName) {
            let size = self.cgfloat(forKey: defaultSize)
            return Font(name: name, size: size)
        }
        return nil
    }

    func set(_ font: Font, forKey defaultName: String, forSize defaultSize: String) {
        self.set(font.fontName , forKey: defaultName)
        self.set(font.pointSize, forKey: defaultSize)
    }
    
    func urlList(forKey defaultName: String) -> [URL] {
        var result = [URL]()
        if let bookmarks = self.object(forKey: defaultName) as? [Data] {
            result.append(bookmarks: bookmarks)
        }
        return result
    }
    
    func set(_ value: [URL], forKey defaultName: String) {
        self.set(value.bookmarks, forKey: defaultName)
    }
    #endif
 
}
