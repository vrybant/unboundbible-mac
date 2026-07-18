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
    
    func rowData(forKey defaultName: String) -> [RowData] {
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

    
}
