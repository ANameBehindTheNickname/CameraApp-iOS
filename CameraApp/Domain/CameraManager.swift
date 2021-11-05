//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import AVFoundation

final class CameraManager: NSObject {
    private var captureSession: AVCaptureSession {
        sessionConfigurator.captureSession
    }
    
    private let sessionConfigurator: SessionConfigurator
    private let photoSaver: PhotoSaver
    private let captureSettings = AVCapturePhotoSettings()
    
    init(_ sessionConfigurator: SessionConfigurator, _ photoSaver: PhotoSaver) {
        self.sessionConfigurator = sessionConfigurator
        self.photoSaver = photoSaver
    }
    
    func flipCamera() {
        sessionConfigurator.sessionQueue.async {
            self.sessionConfigurator.addInput(to: self.sessionConfigurator.captureSession)
        }
    }
    
    func takePhoto() {
        sessionConfigurator.photoOutput.capturePhoto(with: .init(from: captureSettings), delegate: photoSaver)
    }
    
    func setFlashMode(to mode: AVCaptureDevice.FlashMode) {
        captureSettings.flashMode = mode
    }
}
