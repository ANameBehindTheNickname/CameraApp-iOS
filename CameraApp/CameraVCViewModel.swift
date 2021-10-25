//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import AVFoundation

struct CameraVCViewModel {
    let captureSession: AVCaptureSession
    private let sessionQueue = DispatchQueue(label: "com.manbehindnickname.CameraApp.sessionQueue")
    
    func requestCapturePermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configure(captureSession)
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { isGranted in
                if isGranted {
                    configure(captureSession)
                }
            }
        case .restricted, .denied: return
        @unknown default: return
        }
    }
    
    private func configure(_ captureSession: AVCaptureSession) {
        sessionQueue.async {
            captureSession.beginConfiguration()
            addInput(to: captureSession)
            addOutput(to: captureSession)
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
        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
    }
    
    private func makeCameraDevice() -> AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    }
}
