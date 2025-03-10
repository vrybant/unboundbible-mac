//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

struct OptionsScreen: View {
    
    public var body: some View {
             Button("Button") {
                 HomeStore.shared.selection = .bible
            }
    }
}

#Preview {
    OptionsScreen()
}
