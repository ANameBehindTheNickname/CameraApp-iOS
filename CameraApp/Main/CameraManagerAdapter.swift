//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit
import AVFoundation

final class CameraManagerAdapter: CameraControlViewVMDelegate {
    private let cameraManager: CameraManager
    private var captureVideoOrientation: AVCaptureVideoOrientation?
    
    init(_ cameraManager: CameraManager) {
        self.cameraManager = cameraManager
    }
    
    func didChangeCamera() {
        cameraManager.flipCamera()
    }
    
    func didTakePhoto() {
        guard let orientation = captureVideoOrientation else { return }
        cameraManager.takePhoto(with: orientation)
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

extension CameraManagerAdapter: DeviceRotationDelegate {
    func deviceDidRotate(to orientation: UIDeviceOrientation) {
        switch orientation {
        case .portraitUpsideDown: captureVideoOrientation = .portraitUpsideDown
        case .landscapeLeft: captureVideoOrientation = .landscapeLeft
        case .landscapeRight: captureVideoOrientation = .landscapeRight
        default: captureVideoOrientation = .portrait
        }
    }
}
