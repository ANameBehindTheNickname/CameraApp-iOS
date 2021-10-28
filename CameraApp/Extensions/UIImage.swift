//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(withName name: String) {
        if UIImage(systemName: name) != nil {
            self.init(systemName: name)
        } else {
            self.init(named: name)
        }
    }
}
