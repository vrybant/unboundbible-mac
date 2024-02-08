//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import SwiftUI

struct OptionsView: View {
    
    public var body: some View {
             Button("Button") {
                 TabsStore.shared.selection = .bible
            }
    }
}

#Preview {
    OptionsView()
}
