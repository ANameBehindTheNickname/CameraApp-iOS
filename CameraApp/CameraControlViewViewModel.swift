//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import CoreGraphics

final class CameraControlViewViewModel {
    typealias Event = CameraControlStateMachine.Event
    
    private let stateMachine: CameraControlStateMachine
    private let uiConfigurator: CameraControlViewUIConfigurator
    
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
    
    func send(event: Event, completion: (_ tintColorName: String, _ imageName: String) -> Void) {
        stateMachine.updateState(with: event)
        
        var configuration = (tintColorName: "", imageName: "")
        switch event {
        case .onGridTap:
            configuration = gridButtonConfig()
        case .onChangeRatioTap:
            configuration = changeRatioButtonConfig()
        case .onFlashlightTap:
            configuration = flashlightButtonConfig()
        }
        
        completion(configuration.tintColorName, configuration.imageName)
    }
}
