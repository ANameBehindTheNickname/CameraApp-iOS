//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import AVFoundation

extension AVCaptureDevice.Position {
    func flipped() -> AVCaptureDevice.Position {
        switch self {
        case .unspecified, .front:
            return .back
        case .back:
            return .front
        @unknown default:
            return .front
        }
    }
}
