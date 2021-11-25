//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

protocol CameraControlViewVMDelegate: AnyObject {
    func didSetGrid(to state: CameraControlStateMachine.GridButtonState)
    func didChangeCamera()
    func didTakePhoto()
    func didSetRatio(to state: CameraControlStateMachine.ChangeRatioButtonState)
    func didSetFlashlight(to state: CameraControlStateMachine.FlashlightButtonState)
}
