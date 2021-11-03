//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import AVFoundation
import Photos

final class CameraManager: NSObject {
    var captureSession: AVCaptureSession {
        sessionConfigurator.captureSession
    }
    
    private let sessionConfigurator: SessionConfigurator
    
    init(_ sessionConfigurator: SessionConfigurator) {
        self.sessionConfigurator = sessionConfigurator
    }
    
    func requestPermissions() {
        requestCapturePermissions(isGrantedCompletion: requestPhotoLibraryPermissions)
    }
    
    private func requestCapturePermissions(isGrantedCompletion: (() -> (Void))?) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            sessionConfigurator.configure(captureSession)
            isGrantedCompletion?()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isGranted in
                if isGranted {
                    self.sessionConfigurator.configure(self.captureSession)
                    isGrantedCompletion?()
                }
            }
        case .restricted, .denied: return
        @unknown default: return
        }
    }
    
    private func requestPhotoLibraryPermissions() {
        switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
        case .authorized: return
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { _ in }
        case .restricted, .denied, .limited: return
        @unknown default: return
        }
    }
}

extension CameraManager: CameraControlViewDelegate {
    func didTapChangeCameraButton() {
        sessionConfigurator.sessionQueue.async {
            self.sessionConfigurator.addInput(to: self.captureSession)
        }
    }
    
    func didTapTakePhotoButton() {
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
