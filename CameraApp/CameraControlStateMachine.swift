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
        case oneByOne
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
    
    private(set) var gridButtonState = GridButtonState.off
    private(set) var changeRatioButtonState = ChangeRatioButtonState.fourByThree
    private(set) var flashlightButtonState = FlashlightButtonState.auto
    
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
                changeRatioButtonState = .oneByOne
            case .oneByOne:
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
}
