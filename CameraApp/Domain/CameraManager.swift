//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import AVFoundation
import Photos

final class CameraManager: NSObject {
    private var captureSession: AVCaptureSession {
        sessionConfigurator.captureSession
    }
    
    private let sessionConfigurator: SessionConfigurator
    
    init(_ sessionConfigurator: SessionConfigurator) {
        self.sessionConfigurator = sessionConfigurator
    }
    
    func flipCamera() {
        sessionConfigurator.sessionQueue.async {
            self.sessionConfigurator.addInput(to: self.captureSession)
        }
    }
    
    func takePhoto() {
        sessionConfigurator.photoOutput.capturePhoto(with: .init(), delegate: self)
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            return print("Error capturing photo: \(error!)")
        }
        
        switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
        case .authorized:
            
            guard let photoData = photo.fileDataRepresentation() else { return }
            
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: photoData, options: nil)
            } completionHandler: { _, _ in }

        case .notDetermined: return
        case .restricted, .denied, .limited: return
        @unknown default: return
        }
    }
}
