//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

final class CameraManagerAdapter: CameraControlViewDelegate {
    private let cameraManager: CameraManager
    
    init(_ cameraManager: CameraManager) {
        self.cameraManager = cameraManager
    }
    
    func didTapChangeCameraButton() {
        cameraManager.flipCamera()
    }
    
    func didTapTakePhotoButton() {
        cameraManager.takePhoto()
    }
}
