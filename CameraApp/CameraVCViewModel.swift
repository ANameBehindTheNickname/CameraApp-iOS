//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import AVFoundation
import Photos

final class CameraVCViewModel: NSObject {
    let captureSession: AVCaptureSession
    private let sessionQueue = DispatchQueue(label: "com.manbehindnickname.CameraApp.sessionQueue")
    private var deviceInput: AVCaptureDeviceInput?
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
            captureSession.beginConfiguration()
            self.addInput(to: captureSession)
            self.addOutput(to: captureSession)
            captureSession.commitConfiguration()
            captureSession.startRunning()
        }
    }
    
    private func addInput(to captureSession: AVCaptureSession) {
        guard let cameraDevice = makeCameraDevice(),
              let deviceInput = try? AVCaptureDeviceInput(device: cameraDevice),
              captureSession.canAddInput(deviceInput)
        else { return }
        
        self.deviceInput = deviceInput
        captureSession.addInput(deviceInput)
    }
    
    private func addOutput(to captureSession: AVCaptureSession) {
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
    }
    
    private func makeCameraDevice() -> AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    }
}

extension CameraVCViewModel: CameraControlViewDelegate {
    func didTapChangeCameraButton() {
        guard let captureDeviceInput = deviceInput  else { return }
        let captureDevicePosition = captureDeviceInput.device.position
        
        var newCaptureDevice: AVCaptureDevice?
        switch captureDevicePosition {
        case .unspecified, .front:
            newCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        case .back:
            newCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        @unknown default:
            newCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        }
        
        if let newCaptureDevice = newCaptureDevice,
           let newCaptureDeviceInput = try? AVCaptureDeviceInput(device: newCaptureDevice) {
            sessionQueue.async {
                self.captureSession.beginConfiguration()
                self.captureSession.removeInput(captureDeviceInput)
                if self.captureSession.canAddInput(newCaptureDeviceInput) {
                    self.captureSession.addInput(newCaptureDeviceInput)
                    self.deviceInput = newCaptureDeviceInput
                } else {
                    self.captureSession.addInput(captureDeviceInput)
                }
                
                self.captureSession.commitConfiguration()
            }
        }
    }
}
