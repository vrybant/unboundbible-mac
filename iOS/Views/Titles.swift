//
//  Titles.swift
//  Unbound Bible
//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct TitlesView: View {
    @Environment(\.presentationMode) var presentation
    
    public var body: some View {
        
        let titles = currBible?.getTitles() ?? []
        
        List(titles, id: \.self) { item in
            Text(item)            
        }
    }
}
