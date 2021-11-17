//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import Foundation

final class CameraControlStateMachine {
    enum GridButtonState {
        case on
        case off
    }
    
    enum ChangeRatioButtonState {
        case sixteenByNine
        case fourByThree
    }
    
    enum FlashlightButtonState {
        case auto
        case on
        case off
    }
    
    enum Event {
        case onGridTap
        case onChangeCameraTap
        case onTakePhotoTap
        case onChangeRatioTap
        case onFlashlightTap
    }
    
    enum DeviceOrientationState: Int {
        case portrait = 1
        case portraitUpsideDown = 2
        case landscapeLeft = 3
        case landscapeRight = 4
    }
    
    private(set) var gridButtonState = GridButtonState.off
    private(set) var changeRatioButtonState = ChangeRatioButtonState.fourByThree
    private(set) var flashlightButtonState = FlashlightButtonState.auto
    private(set) var deviceOrientationState: DeviceOrientationState?
    
    func updateState(with event: Event) {
        switch event {
        case .onGridTap:
            switch gridButtonState {
            case .on:
                gridButtonState = .off
            case .off:
                gridButtonState = .on
            }
        case .onChangeRatioTap:
            switch changeRatioButtonState {
            case .sixteenByNine:
                changeRatioButtonState = .fourByThree
            case .fourByThree:
                changeRatioButtonState = .sixteenByNine
            }
        case .onFlashlightTap:
            switch flashlightButtonState {
            case .auto:
                flashlightButtonState = .on
            case .on:
                flashlightButtonState = .off
            case .off:
                flashlightButtonState = .auto
            }
        case .onChangeCameraTap, .onTakePhotoTap: break
        }
    }
    
    func updateDeviceOrientationState(to newState: DeviceOrientationState) {
        deviceOrientationState = newState
    }
}
