//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit

extension Bundle {
    @discardableResult
    func loadNib(_ aClass: AnyClass, owner: Any?, options: [UINib.OptionsKey : Any]? = nil) -> [Any]? {
        loadNibNamed(String(describing: aClass), owner: owner, options: options)
    }
}
