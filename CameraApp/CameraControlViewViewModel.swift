//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import CoreGraphics

final class CameraControlViewViewModel {
    private enum GridButtonState {
        case on
        case off
    }
    
    private enum ChangeRatioButtonState {
        case sixteenByNine
        case fourByThree
        case oneByOne
    }
    
    private enum FlashlightButtonState {
        case auto
        case on
        case off
    }
    
    enum Event {
        case onGridTap
        case onChangeRatioTap
        case onFlashlightTap
    }
    
    private var gridButtonState = GridButtonState.off
    private var changeRatioButtonState = ChangeRatioButtonState.fourByThree
    private var flashlightButtonState = FlashlightButtonState.auto
    
    func gridButtonConfig() -> (tintColorName: String, imageName: String) {
        switch gridButtonState {
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
    
    func changeRatioButtonConfig() -> (tintColorName: String, imageName: String) {
        switch changeRatioButtonState {
        case .sixteenByNine: return ("white", "sixteenByNine")
        case .fourByThree: return ("white", "fourByThree")
        case .oneByOne: return ("white", "aspectratio")
        }
    }
    
    func flashlightButtonConfig() -> (tintColorName: String, imageName: String) {
        switch flashlightButtonState {
        case .auto: return ("yellow", "bolt.badge.a")
        case .on: return ("yellow", "bolt")
        case .off: return ("white", "bolt.slash")
        }
    }
    
    func send(event: Event, completion: (_ tintColorName: String, _ imageName: String) -> Void) {
        switch event {
        case .onGridTap:
            switch gridButtonState {
            case .on:
                gridButtonState = .off
            case .off:
                gridButtonState = .on
            }
            
            completion(gridButtonConfig().tintColorName, gridButtonConfig().imageName)
        case .onChangeRatioTap:
            switch changeRatioButtonState {
            case .sixteenByNine:
                changeRatioButtonState = .fourByThree
            case .fourByThree:
                changeRatioButtonState = .oneByOne
            case .oneByOne:
                changeRatioButtonState = .sixteenByNine
            }
            
            completion(changeRatioButtonConfig().tintColorName, changeRatioButtonConfig().imageName)
        case .onFlashlightTap:
            switch flashlightButtonState {
            case .auto:
                flashlightButtonState = .on
            case .on:
                flashlightButtonState = .off
            case .off:
                flashlightButtonState = .auto
            }
            
            completion(flashlightButtonConfig().tintColorName, flashlightButtonConfig().imageName)
        }
    }
}
