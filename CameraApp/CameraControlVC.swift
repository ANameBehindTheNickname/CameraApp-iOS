//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit

final class CameraControlVC: UIViewController {
    
    private let cameraControlVM: CameraControlViewViewModel
    
    init(cameraControlVM: CameraControlViewViewModel) {
        self.cameraControlVM = cameraControlVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cameraControlView: CameraControlView {
        view as! CameraControlView
    }
    
    override func loadView() {
        view = CameraControlView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraControlView.viewModel = cameraControlVM
    }
}
