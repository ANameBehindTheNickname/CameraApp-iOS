//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit

final class CameraControlView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet var buttonStack: UIStackView!
    
    @IBOutlet private(set) var gridButton: UIButton!
    @IBOutlet private(set) var changeCameraButton: UIButton!
    @IBOutlet private(set) var takePhotoButton: UIButton!
    @IBOutlet private(set) var changeRatioButton: UIButton!
    @IBOutlet private(set) var flashlightButton: UIButton!
    
    @IBAction private func changeGridSetting(_ sender: UIButton) {
        viewModel?.send(event: .onGridTap) { tintColorName, imageName in
            update(sender, with: tintColorName, and: imageName)
        }
    }
    
    @IBAction private func changeRatioSetting(_ sender: UIButton) {
        viewModel?.send(event: .onChangeRatioTap) { tintColorName, imageName in
            update(sender, with: tintColorName, and: imageName)
        }
    }
    
    @IBAction private func changeFlashlightSetting(_ sender: UIButton) {
        viewModel?.send(event: .onFlashlightTap) { tintColorName, imageName in
            update(sender, with: tintColorName, and: imageName)
        }
    }
    
    var viewModel: CameraControlViewViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            fill(from: viewModel)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNib(CameraControlView.self, owner: self)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        contentView.backgroundColor = .clear
        buttonStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        buttonStack.isLayoutMarginsRelativeArrangement = true
    }
    
    private func fill(from viewModel: CameraControlViewViewModel) {
        let (gridColorName, gridImageName) = viewModel.gridButtonConfig()
        gridButton.setImage(.init(withName: gridImageName), for: .normal)
        gridButton.tintColor = .init(named: gridColorName)
        
        let (changeCameraColorName, changeCameraImageName) = viewModel.changeCameraButtonConfig()
        changeCameraButton.setImage(.init(withName: changeCameraImageName), for: .normal)
        changeCameraButton.tintColor = .init(named: changeCameraColorName)
        
        let (takePhotoColorName, takePhotoImageName, pointSize) = viewModel.takePhotoButtonConfig()
        takePhotoButton.setImage(.init(withName: takePhotoImageName), for: .normal)
        takePhotoButton.tintColor = .init(named: takePhotoColorName)
        takePhotoButton.setPreferredSymbolConfiguration(.init(pointSize: pointSize), forImageIn: .normal)
        
        let (changeRatioColorName, changeRatioImageName) = viewModel.changeRatioButtonConfig()
        changeRatioButton.setImage(.init(withName: changeRatioImageName), for: .normal)
        changeRatioButton.tintColor = .init(named: changeRatioColorName)
        
        let (flashlightColorName, flashlightImageName) = viewModel.flashlightButtonConfig()
        flashlightButton.setImage(.init(withName: flashlightImageName), for: .normal)
        flashlightButton.tintColor = .init(named: flashlightColorName)
    }
    
    private func update(_ button: UIButton, with tintColorName: String, and imageName: String ) {
        button.tintColor = .init(named: tintColorName)
        button.setImage(.init(withName: imageName), for: .normal)
    }
}
