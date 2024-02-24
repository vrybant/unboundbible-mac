//
//  Unbound Bible
//  Copyright © Vladimir Rybant.
//

import Foundation
import SwiftUI

enum SafeTitleDisplayMode {
    case automatic
    case inline
    case large
    
    #if !os(macOS)
        var titleDisplayMode: NavigationBarItem.TitleDisplayMode {
            switch self {
            case .automatic: .automatic
            case .inline: .inline
            case .large: .large
            }
        }
    #endif
}

extension View {
    @ViewBuilder
    func safeNavigationBarTitleDisplayMode(_ displayMode: SafeTitleDisplayMode) -> some View {
        #if !os(macOS)
        navigationBarTitleDisplayMode(displayMode.titleDisplayMode)
        #else
            self
        #endif
    }
}
