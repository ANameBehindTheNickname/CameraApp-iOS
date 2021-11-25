//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import CoreGraphics

final class CameraControlViewUIConfigurator {
    func gridButtonConfig(for state: CameraControlStateMachine.GridButtonState) -> (tintColorName: String, imageName: String) {
        switch state {
        case .on: return ("yellow", "rectangle.split.3x3")
        case .off: return ("white", "rectangle.split.3x3")
        }
    }
    
    func changeCameraButtonConfig() -> (tintColorName: String, imageName: String) {
        ("white", "arrow.triangle.2.circlepath.camera")
    }
    
    func takePhotoButtonConfig() -> (tintColorName: String, imageName: String, pointSize: CGFloat) {
        ("white", "largecircle.fill.circle", 55)
    }
    
    func changeRatioButtonConfig(for state: CameraControlStateMachine.ChangeRatioButtonState) -> (tintColorName: String, imageName: String) {
        switch state {
        case .sixteenByNine: return ("white", "sixteenByNine")
        case .fourByThree: return ("white", "fourByThree")
        }
    }
    
    func flashlightButtonConfig(for state: CameraControlStateMachine.FlashlightButtonState) -> (tintColorName: String, imageName: String) {
        switch state {
        case .auto: return ("yellow", "bolt.badge.a")
        case .on: return ("yellow", "bolt")
        case .off: return ("white", "bolt.slash")
        }
    }
}
