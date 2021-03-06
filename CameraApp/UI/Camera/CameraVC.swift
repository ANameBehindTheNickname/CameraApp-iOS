//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit

final class CameraVC: UIViewController {

    private let previewView: PreviewView
    var onViewDidLoad = { }
    var onGridTap = { }
    
    init(_ previewView: PreviewView) {
        self.previewView = previewView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = previewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }
}
