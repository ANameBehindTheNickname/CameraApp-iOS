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
    
    func configure(_ captureSession: AVCaptureSession) {
        sessionQueue.async {
            self.addInput(to: captureSession)
            self.addOutput(to: captureSession)
            captureSession.startRunning()
        }
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
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
    }
}
