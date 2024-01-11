//
//  ModulesView.swift
//  SwiftUI
//
//  Created by Vladimir Rybant on 11.01.2024.
//  Copyright © 2024 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct ModulesView: View {
    public var body: some View {
        
        let list = tools.get_Shelf()
        
        List(list, id: \.self) { item in
            Text(item)
                .onTapGesture {
                    print(item)
                }
        }
    }
}

#Preview {
    ModulesView()
}
