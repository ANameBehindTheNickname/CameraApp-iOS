//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import CoreGraphics

final class CameraControlViewViewModel {
    enum GridButtonState {
        case on
        case off
    }
    
    private enum ChangeRatioButtonState {
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
        case onChangeRatioTap
        case onFlashlightTap
    }
    
    private(set) var gridButtonState = GridButtonState.off
    private var changeRatioButtonState = ChangeRatioButtonState.fourByThree
    private(set) var flashlightButtonState = FlashlightButtonState.auto
    
    let gridButtonImageName = "rectangle.split.3x3"
    let changeCameraButtonImageName = "arrow.triangle.2.circlepath.camera"
    let takePhotoButtonImageName = "largecircle.fill.circle"
    let takePhotoButtonSymbolSize: CGFloat = 55
    var changeRatioButtonImageName = "sixteenByNine"
    var flashlightButtonImageName = "bolt.badge.a"
    
    func send(event: Event, completion: (_ tintColorName: String, _ imageName: String) -> Void) {
        switch event {
        case .onGridTap:
            switch gridButtonState {
            case .on:
                gridButtonState = .off
                completion("white", "rectangle.split.3x3")
            case .off:
                gridButtonState = .on
                completion("yellow", "rectangle.split.3x3")
            }
        case .onChangeRatioTap:
            switch changeRatioButtonState {
            case .sixteenByNine:
                changeRatioButtonState = .fourByThree
                completion("white", "fourByThree")
            case .fourByThree:
                changeRatioButtonState = .oneByOne
                completion("white", "aspectratio")
            case .oneByOne:
                changeRatioButtonState = .sixteenByNine
                completion("white", "sixteenByNine")
            }
        case .onFlashlightTap:
            switch flashlightButtonState {
            case .auto:
                flashlightButtonState = .on
                completion("yellow", "bolt")
            case .on:
                flashlightButtonState = .off
                completion("white", "bolt.slash")
            case .off:
                flashlightButtonState = .auto
                completion("yellow", "bolt.badge.a")
            }
        }
    }
}
