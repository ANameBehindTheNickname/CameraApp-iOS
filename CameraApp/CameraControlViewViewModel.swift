//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import CoreGraphics

protocol CameraControlViewViewModelObserver {
    func viewModel(didUpdateGridButtonTo tintColorName: String, imageName: String)
    func viewModel(didUpdateChangeRatioButtonTo tintColorName: String, imageName: String)
    func viewModel(didUpdateFlashlightButtonTo tintColorName: String, imageName: String)
}

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
    
    var observer: CameraControlViewViewModelObserver?
    
    func send(event: Event) {
        switch event {
        case .onGridTap:
            switch gridButtonState {
            case .on:
                gridButtonState = .off
                observer?.viewModel(didUpdateGridButtonTo: "white", imageName: "rectangle.split.3x3")
            case .off:
                gridButtonState = .on
                observer?.viewModel(didUpdateGridButtonTo: "yellow", imageName: "rectangle.split.3x3")
            }
        case .onChangeRatioTap:
            switch changeRatioButtonState {
            case .sixteenByNine:
                changeRatioButtonState = .fourByThree
                observer?.viewModel(didUpdateChangeRatioButtonTo: "white", imageName: "fourByThree")
            case .fourByThree:
                changeRatioButtonState = .oneByOne
                observer?.viewModel(didUpdateChangeRatioButtonTo: "white", imageName: "aspectratio")
            case .oneByOne:
                changeRatioButtonState = .sixteenByNine
                observer?.viewModel(didUpdateChangeRatioButtonTo: "white", imageName: "sixteenByNine")
            }
        case .onFlashlightTap:
            switch flashlightButtonState {
            case .auto:
                flashlightButtonState = .on
                observer?.viewModel(didUpdateFlashlightButtonTo: "yellow", imageName: "bolt")
            case .on:
                flashlightButtonState = .off
                observer?.viewModel(didUpdateFlashlightButtonTo: "white", imageName: "bolt.slash")
            case .off:
                flashlightButtonState = .auto
                observer?.viewModel(didUpdateFlashlightButtonTo: "yellow", imageName: "bolt.badge.a")
            }
        }
    }
}
