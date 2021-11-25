//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import AVFoundation
import Photos

final class PermissionsManager {
    func requestPermissions(isGrantedCompletion: (() -> (Void))?) {
        requestCapturePermission(isGrantedCompletion: isGrantedCompletion)
    }
    
    private func requestCapturePermission(isGrantedCompletion: (() -> (Void))?) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isGrantedCompletion?()
            self.requestPhotoLibraryPermission()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isGranted in
                if isGranted {
                    isGrantedCompletion?()
                    self.requestPhotoLibraryPermission()
                }
            }
        case .restricted, .denied: return
        @unknown default: return
        }
    }
    
    private func requestPhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
        case .authorized: return
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { _ in }
        case .restricted, .denied, .limited: return
        @unknown default: return
        }
    }
}
