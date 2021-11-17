//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit

protocol DeviceRotationDelegate: AnyObject {
    func deviceDidRotate(to orientation: UIDeviceOrientation)
}
