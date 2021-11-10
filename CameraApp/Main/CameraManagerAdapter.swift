//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

final class CameraManagerAdapter: CameraControlViewVMDelegate {
    private let cameraManager: CameraManager
    private let previewView: PreviewView
    
    init(_ cameraManager: CameraManager, _ previewView: PreviewView) {
        self.cameraManager = cameraManager
        self.previewView = previewView
    }
    
    func didChangeCamera() {
        cameraManager.flipCamera()
    }
    
    func didTakePhoto() {
        cameraManager.takePhoto(with: previewView.videoLayer.connection?.videoOrientation ?? .portrait)
    }
    
    func didSetRatio(to state: CameraControlStateMachine.ChangeRatioButtonState) {
        switch state {
        case .sixteenByNine: cameraManager.setResolution(to: .hd1280x720)
        case .fourByThree: cameraManager.setResolution(to: .photo)
        }
    }
    
    func didSetFlashlight(to state: CameraControlStateMachine.FlashlightButtonState) {
        switch state {
        case .auto: cameraManager.setFlashMode(to: .auto)
        case .on: cameraManager.setFlashMode(to: .on)
        case .off: cameraManager.setFlashMode(to: .off)
        }
    }
}
