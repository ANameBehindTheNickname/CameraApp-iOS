//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

final class CameraManagerAdapter: CameraControlViewVMDelegate {
    private let cameraManager: CameraManager
    
    init(_ cameraManager: CameraManager) {
        self.cameraManager = cameraManager
    }
    
    func didChangeCamera() {
        cameraManager.flipCamera()
    }
    
    func didTakePhoto() {
        cameraManager.takePhoto()
    }
}
