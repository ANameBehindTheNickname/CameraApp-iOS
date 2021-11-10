//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit

final class CameraControlVC: UIViewController {
    
    private let cameraControlView: CameraControlView
    let cameraControlVM: CameraControlViewViewModel
    
    init(cameraControlView: CameraControlView, cameraControlVM: CameraControlViewViewModel) {
        self.cameraControlView = cameraControlView
        self.cameraControlVM = cameraControlVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = cameraControlView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraControlView.viewModel = cameraControlVM
    }
}
