//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit

final class DeviceRotationComposite: DeviceRotationDelegate {
    private let delegates: [DeviceRotationDelegate]
    
    init(_ delegates: [DeviceRotationDelegate]) {
        self.delegates = delegates
    }
    
    func deviceDidRotate(to orientation: UIDeviceOrientation) {
        delegates.forEach { $0.deviceDidRotate(to: orientation) }
    }
}
