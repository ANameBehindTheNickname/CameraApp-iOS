//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit

final class CameraVC: UIViewController {

    private let viewModel: CameraVCViewModel
    
    init(viewModel: CameraVCViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PreviewView()
    }
    
    var previewView: PreviewView {
        view as! PreviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.requestPermissions()
        previewView.videoLayer.session = viewModel.captureSession
    }
}
