//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit
import AVFoundation
import Rotations

final class CameraManagerAdapter: CameraControlViewVMDelegate {
    var onGridTap: (() -> Void)?
    
    private let cameraManager: CameraManager
    private var captureVideoOrientation: AVCaptureVideoOrientation?
    
    init(_ cameraManager: CameraManager) {
        self.cameraManager = cameraManager
    }
    
    func didSetGrid(to state: CameraControlStateMachine.GridButtonState) {
        onGridTap?()
    }
    
    func didChangeCamera() {
        cameraManager.flipCamera()
    }
    
    func didTakePhoto() {
        guard let orientation = captureVideoOrientation else { return }
        cameraManager.takePhoto(with: orientation)
    }
    
    func didSetRatio(to state: CameraControlStateMachine.ChangeRatioButtonState) {
        DispatchQueue.global().async {
            switch state {
            case .sixteenByNine: self.cameraManager.setResolution(to: .hd1280x720)
            case .fourByThree: self.cameraManager.setResolution(to: .photo)
            }
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

extension CameraManagerAdapter: RotationManagerDelegate {
    func deviceDidRotate(to orientation: UIDeviceOrientation) {
        switch orientation {
        case .portraitUpsideDown: captureVideoOrientation = .portraitUpsideDown
        case .landscapeLeft: captureVideoOrientation = .landscapeRight
        case .landscapeRight: captureVideoOrientation = .landscapeLeft
        default: captureVideoOrientation = .portrait
        }
    }
}
