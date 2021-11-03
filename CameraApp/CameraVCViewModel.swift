//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import AVFoundation
import Photos

final class CameraVCViewModel: NSObject {
    let captureSession: AVCaptureSession
    private let sessionQueue = DispatchQueue(label: "com.manbehindnickname.CameraApp.sessionQueue")
    private let photoOutput = AVCapturePhotoOutput()
    
    init(captureSession: AVCaptureSession) {
        self.captureSession = captureSession
    }
    
    func requestPermissions() {
        requestCapturePermissions(isGrantedCompletion: requestPhotoLibraryPermissions)
    }
    
    private func requestCapturePermissions(isGrantedCompletion: (() -> (Void))?) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configure(captureSession)
            isGrantedCompletion?()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isGranted in
                if isGranted {
                    self.configure(self.captureSession)
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
    
    private func configure(_ captureSession: AVCaptureSession) {
        sessionQueue.async {
            self.addInput(to: captureSession)
            self.addOutput(to: captureSession)
            captureSession.startRunning()
        }
    }
    
    private func addInput(to captureSession: AVCaptureSession) {
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        let position = removeCurrentDeviceInput(from: captureSession)?.device.position.flipped() ?? .front

        if let cameraDevice = cameraDevice(for: position),
              let newDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice),
              captureSession.canAddInput(newDeviceInput) {
            captureSession.addInput(newDeviceInput)
        }
    }
    
    private func removeCurrentDeviceInput(from session: AVCaptureSession) -> AVCaptureDeviceInput? {
        (captureSession.inputs.first as? AVCaptureDeviceInput).map {
            captureSession.removeInput($0)
            return $0
        }
    }
    
    private func cameraDevice(for position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
    }
    
    private func addOutput(to captureSession: AVCaptureSession) {
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
    }
}

extension CameraVCViewModel: CameraControlViewDelegate {
    func didTapChangeCameraButton() {
        sessionQueue.async {
            self.addInput(to: self.captureSession)
        }
    }
}
