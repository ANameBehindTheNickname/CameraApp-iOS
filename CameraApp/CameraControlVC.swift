//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit

final class CameraControlVC: UIViewController {
    override func loadView() {
        view = CameraControlView()
    }
    
    var cameraControlView: CameraControlView {
        view as! CameraControlView
    }
}
