//
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import Foundation

extension UserDefaults {
    func cgfloat(forKey defaultName: String) -> CGFloat {
        CGFloat(self.float(forKey: defaultName))
    }
}
