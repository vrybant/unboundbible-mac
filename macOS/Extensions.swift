//
//  Extensions.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation
import Cocoa

extension Collection where Iterator.Element == String {
    
    func lowercased() -> [String] {
        var result : [String] = []
        for string in self { result.append(string.lowercased()) }
        return result
    }
    
    func highlight(with: String, target: String, options: SearchOption) -> [String] {
        var result : [String] = []
        for string in self { result.append(string.highlight(with: with, target: target, options: options)) }
        return result
    }
    
}

extension NSTabView {
    var selectedTab: String? {
        if let item = selectedTabViewItem {
            return item.identifier as? String
        }
        return nil
    }
}

let programmatically = 1

extension NSTableView {
    func selectRow(index: Int) {
        self.tag = programmatically
        let indexSet = NSIndexSet(index: index)
        self.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        self.scrollRowToVisible(index)
        self.tag = 0
    }
}

extension NSAppearance {
    var isDark: Bool {
        let appearance: NSAppearance.Name? = self.bestMatch(from: [.aqua, .darkAqua])
        return appearance == .darkAqua
    }
}

extension NSViewController {
    var isViewVisible: Bool {
        if !isViewLoaded { return false }
        return view.window != nil
    }
}
