//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

protocol CameraControlViewVMDelegate: AnyObject {
    func didChangeCamera()
    func didTakePhoto()
    func didSetFlashlight(to state: CameraControlStateMachine.FlashlightButtonState)
}
