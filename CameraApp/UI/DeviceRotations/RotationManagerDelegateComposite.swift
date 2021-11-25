//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit
import Rotations

final class RotationManagerDelegateComposite: RotationManagerDelegate {
    private let delegates: [RotationManagerDelegate]
    
    init(_ delegates: [RotationManagerDelegate]) {
        self.delegates = delegates
    }
    
    func deviceDidRotate(to orientation: UIDeviceOrientation) {
        delegates.forEach { $0.deviceDidRotate(to: orientation) }
    }
}
