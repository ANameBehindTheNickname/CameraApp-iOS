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
    
    @IBAction private func changeGridSetting(_ sender: UIButton) { viewModel?.send(event: .onGridTap)}
    @IBAction private func changeRatioSetting(_ sender: UIButton) { viewModel?.send(event: .onChangeRatioTap) }
    @IBAction private func changeFlashlightSetting(_ sender: UIButton) { viewModel?.send(event: .onFlashlightTap) }
    
    var viewModel: CameraControlViewViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            viewModel.observer = self
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
        gridButton.setImage(.init(systemName: viewModel.gridButtonImageName), for: .normal)
        switch viewModel.gridButtonState {
        case .on: gridButton.tintColor = .yellow
        case .off: gridButton.tintColor = .white
        }
        
        changeCameraButton.setImage(.init(systemName: viewModel.changeCameraButtonImageName), for: .normal)
        changeCameraButton.tintColor = .white
        
        takePhotoButton.setImage(.init(systemName: viewModel.takePhotoButtonImageName), for: .normal)
        takePhotoButton.setPreferredSymbolConfiguration(.init(pointSize: viewModel.takePhotoButtonSymbolSize), forImageIn: .normal)
        takePhotoButton.tintColor = .white
        
        changeRatioButton.setImage(.init(named: viewModel.changeRatioButtonImageName), for: .normal)
        changeRatioButton.tintColor = .white
        
        flashlightButton.setImage(.init(systemName: viewModel.flashlightButtonImageName), for: .normal)
        switch viewModel.flashlightButtonState {
        case .auto: flashlightButton.tintColor = .yellow
        case .on: flashlightButton.tintColor = .yellow
        case .off: flashlightButton.tintColor = .white
        }
    }
}

extension CameraControlView: CameraControlViewViewModelObserver {
    func viewModel(didUpdateGridButtonTo tintColorName: String, imageName: String) {
        gridButton.tintColor = .init(named: tintColorName)
        gridButton.setImage(.init(withName: imageName), for: .normal)
    }
    
    func viewModel(didUpdateChangeRatioButtonTo tintColorName: String, imageName: String) {
        changeRatioButton.tintColor = .init(named: tintColorName)
        changeRatioButton.setImage(.init(withName: imageName), for: .normal)
    }
    
    func viewModel(didUpdateFlashlightButtonTo tintColorName: String, imageName: String) {
        flashlightButton.tintColor = .init(named: tintColorName)
        flashlightButton.setImage(.init(withName: imageName), for: .normal)
    }
}
