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
            captureSession.beginConfiguration()
            self.addInput(to: captureSession)
            self.addOutput(to: captureSession)
            captureSession.commitConfiguration()
            captureSession.startRunning()
        }
    }
    
    private func addInput(to captureSession: AVCaptureSession) {
        guard let videoDevice = makeCameraDevice(),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoDeviceInput)
        else { return }
        
        captureSession.addInput(videoDeviceInput)
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
