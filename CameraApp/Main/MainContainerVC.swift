//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit

final class MainContainerVC: UIViewController {
    private let cameraVC: UIViewController
    private let cameraControlVC: UIViewController
    private lazy var cameraControlCompactVerticalConstraint =
        cameraControlVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    
    private lazy var cameraControlRegularVerticalConstraint =
        cameraControlVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
    
    init(cameraVC: UIViewController, cameraControlVC: UIViewController) {
        self.cameraVC = cameraVC
        self.cameraControlVC = cameraControlVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [cameraVC, cameraControlVC].forEach { addChildVC($0) }
        constraintSubviews()
    }
    
    private func addChildVC(_ childController: UIViewController) {
        addChild(childController)
        view.addSubview(childController.view)
        childController.didMove(toParent: self)
    }
    
    private func constraintSubviews() {
        cameraVC.view.translatesAutoresizingMaskIntoConstraints = false
        cameraControlVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        (traitCollection.verticalSizeClass == .compact
            ? cameraControlCompactVerticalConstraint
            : cameraControlRegularVerticalConstraint).isActive = true
        
        NSLayoutConstraint.activate([
            cameraVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cameraVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cameraVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            cameraControlVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cameraControlVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass else { return }
        
        let isCompact = traitCollection.verticalSizeClass == .compact
        cameraControlCompactVerticalConstraint.isActive = isCompact
        cameraControlRegularVerticalConstraint.isActive = !isCompact
    }
}
