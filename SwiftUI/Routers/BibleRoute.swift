//
//  Unbound Bible
//  Copyright © Vladimir Rybant. 
//

import SwiftUI

enum BibleRoute:  View, Hashable {
    case books
    case chapters(String)
    
    var body: some View {
        switch self {
            case .books:
                BooksView()
            case .chapters(let name):
                ChaptersView(name: name)
        }
    }
}
