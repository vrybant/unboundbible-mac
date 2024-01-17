//
//  Unbound Bible
//
//  Copyright © Vladimir Rybant. All rights reserved.
//

import SwiftUI

public struct BibleView: View {
    
    private var router = Router.shared
    
    @State private var centerText = ""
    @State private var showLeftAlert: Bool = false
    @State private var showRightAlert: Bool = false
    
    public var body: some View {
        
        @Bindable var router = router

        NavigationStack(path: $router.bibleRoutes) {
            ScriprureView()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button("Bible") {
                        router.bibleRoutes.append(.books)
                    }
                }
            }
            .navigationDestination(for: BibleRoute.self) { route in
                route.destination
            }
        }
        
    }
}
