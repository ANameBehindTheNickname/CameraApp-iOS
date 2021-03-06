//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import AVFoundation

final class SessionConfigurator {
    let captureSession: AVCaptureSession
    let sessionQueue = DispatchQueue(label: "com.manbehindnickname.CameraApp.sessionQueue")
    let photoOutput = AVCapturePhotoOutput()
    
    init(captureSession: AVCaptureSession) {
        self.captureSession = captureSession
    }
    
    func configure() {
        sessionQueue.async {
            self.addInput(to: self.captureSession)
            self.addOutput(to: self.captureSession)
            self.captureSession.startRunning()
        }
    }
    
    func set(_ preset: AVCaptureSession.Preset) {
        captureSession.sessionPreset = captureSession.canSetSessionPreset(preset) ? preset : .photo
    }
    
    func addInput(to captureSession: AVCaptureSession) {
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
        captureSession.addOutput(photoOutput)
    }
}
