//
//  Unbound Bible
//  Copyright © Vladimir Rybant
//

import Foundation

extension UserDefaults {
    func cgfloat(forKey defaultName: String) -> CGFloat {
        CGFloat(self.float(forKey: defaultName))
    }
}
