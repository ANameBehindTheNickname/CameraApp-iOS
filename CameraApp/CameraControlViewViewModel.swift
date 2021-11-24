//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import CoreGraphics

final class CameraControlViewViewModel {
    typealias Event = CameraControlStateMachine.Event
    typealias Orientation = CameraControlStateMachine.DeviceOrientationState
    
    private let stateMachine: CameraControlStateMachine
    private let uiConfigurator: CameraControlViewUIConfigurator
    private let controlAnimationDuration = 0.25
    
    weak var delegate: CameraControlViewVMDelegate?
    
    init(_ stateMachine: CameraControlStateMachine, _ uiConfigurator: CameraControlViewUIConfigurator) {
        self.stateMachine = stateMachine
        self.uiConfigurator = uiConfigurator
    }
    
    func gridButtonConfig() -> (tintColorName: String, imageName: String) {
        uiConfigurator.gridButtonConfig(for: stateMachine.gridButtonState)
    }
    
    func changeCameraButtonConfig() -> (tintColorName: String, imageName: String) {
        uiConfigurator.changeCameraButtonConfig()
    }
    
    func takePhotoButtonConfig() -> (tintColorName: String, imageName: String, pointSize: CGFloat) {
        uiConfigurator.takePhotoButtonConfig()
    }
    
    func changeRatioButtonConfig() -> (tintColorName: String, imageName: String) {
        uiConfigurator.changeRatioButtonConfig(for: stateMachine.changeRatioButtonState)
    }
    
    func flashlightButtonConfig() -> (tintColorName: String, imageName: String) {
        uiConfigurator.flashlightButtonConfig(for: stateMachine.flashlightButtonState)
    }
    
    func send(event: Event, completion: ((String, String)?) -> Void) {
        stateMachine.updateState(with: event)
        
        var configuration = (String, String)?.none
        switch event {
        case .onGridTap:
            configuration = gridButtonConfig()
        case .onChangeRatioTap:
            configuration = changeRatioButtonConfig()
            delegate?.didSetRatio(to: stateMachine.changeRatioButtonState)
        case .onFlashlightTap:
            configuration = flashlightButtonConfig()
            delegate?.didSetFlashlight(to: stateMachine.flashlightButtonState)
        case .onChangeCameraTap:
            delegate?.didChangeCamera()
        case .onTakePhotoTap:
            delegate?.didTakePhoto()
        }
        
        completion(configuration)
    }
    
    func rotationAnimationSettings(from orientation: Orientation) -> (CGFloat, duration: Double) {
        let oldOrientation = stateMachine.deviceOrientationState
        stateMachine.updateDeviceOrientationState(to: orientation)
        switch (oldOrientation, orientation) {
        case (.portrait, .landscapeLeft),
             (.landscapeRight, .portrait),
             (.portraitUpsideDown, .landscapeRight),
             (.landscapeLeft, .portraitUpsideDown),
             (.unknown, .landscapeLeft): return (90, controlAnimationDuration)
            
        case (.landscapeLeft, .portrait),
             (.portrait, .landscapeRight),
             (.landscapeRight, .portraitUpsideDown),
             (.portraitUpsideDown, .landscapeLeft),
             (.unknown, .landscapeRight): return (-90, controlAnimationDuration)
            
        case (.portrait, .portraitUpsideDown),
             (.portraitUpsideDown, .portrait),
             (.landscapeLeft, .landscapeRight),
             (.landscapeRight, .landscapeLeft),
             (.unknown, .portraitUpsideDown): return (180, controlAnimationDuration)
            
        case (nil, .landscapeLeft): return (90, 0)
        case (nil, .landscapeRight): return (-90, 0)
        case (nil, .portraitUpsideDown): return (180, 0)
            
        default: return (0, 0)
        }
    }
}
