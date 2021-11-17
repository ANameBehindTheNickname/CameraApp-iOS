//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit

final class CameraControlView: UIView {
    typealias ViewModel = CameraControlViewViewModel
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var buttonStack: UIStackView!
    
    @IBOutlet private var gridButton: UIButton!
    @IBOutlet private var changeCameraButton: UIButton!
    @IBOutlet private var takePhotoButton: UIButton!
    @IBOutlet private var changeRatioButton: UIButton!
    @IBOutlet private var flashlightButton: UIButton!
    
    @IBAction private func changeGridSetting(_ sender: UIButton) {
        send(.onGridTap, from: sender)
    }
    
    @IBAction private func changeCamera(_ sender: UIButton) {
        send(.onChangeCameraTap, from: sender)
    }
    
    @IBAction private func takePhoto(_ sender: UIButton) {
        send(.onTakePhotoTap, from: sender)
    }
    
    @IBAction private func changeRatioSetting(_ sender: UIButton) {
        send(.onChangeRatioTap, from: sender)
    }
    
    @IBAction private func changeFlashlightSetting(_ sender: UIButton) {
        send(.onFlashlightTap, from: sender)
    }
    
    var viewModel: ViewModel? {
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
        setupSubviews()
        constraintSubviews()
    }
    
    private func setupSubviews() {
        addSubview(contentView)
        contentView.backgroundColor = .clear
        
        buttonStack.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        buttonStack.isLayoutMarginsRelativeArrangement = true
        
        changeRatioButton.imageView?.contentMode = .scaleAspectFit
    }
    
    private func constraintSubviews() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        [gridButton, changeCameraButton, changeRatioButton, flashlightButton].forEach {
            $0?.widthAnchor.constraint(equalToConstant: 30).isActive = true
            $0?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        takePhotoButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        takePhotoButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func fill(from viewModel: ViewModel) {
        let (gridColorName, gridImageName) = viewModel.gridButtonConfig()
        update(gridButton, with: gridColorName, and: gridImageName)
        
        let (changeCameraColorName, changeCameraImageName) = viewModel.changeCameraButtonConfig()
        update(changeCameraButton, with: changeCameraColorName, and: changeCameraImageName)
        
        let (takePhotoColorName, takePhotoImageName, pointSize) = viewModel.takePhotoButtonConfig()
        update(takePhotoButton, with: takePhotoColorName, and: takePhotoImageName)
        takePhotoButton.setPreferredSymbolConfiguration(.init(pointSize: pointSize), forImageIn: .normal)
        
        let (changeRatioColorName, changeRatioImageName) = viewModel.changeRatioButtonConfig()
        update(changeRatioButton, with: changeRatioColorName, and: changeRatioImageName)
        
        let (flashlightColorName, flashlightImageName) = viewModel.flashlightButtonConfig()
        update(flashlightButton, with: flashlightColorName, and: flashlightImageName)
    }
    
    private func send(_ event: ViewModel.Event, from button: UIButton) {
        viewModel?.send(event: event) {
            $0.map { (tintColorName, imageName) in
                update(button, with: tintColorName, and: imageName)
            }
        }
    }
    
    private func update(_ button: UIButton, with tintColorName: String, and imageName: String ) {
        button.tintColor = .init(named: tintColorName)
        button.setImage(.init(withName: imageName), for: .normal)
    }
}

extension CameraControlView: DeviceRotationDelegate {
    func deviceDidRotate(to orientation: UIDeviceOrientation) {
        guard let viewModel = viewModel else { return }
        
        let orientation = deviceOrientation(from: orientation) ?? viewModel.defaultOrientation
        let (angle, duration) = viewModel.rotationAnimationSettings(from: orientation)
        
        DispatchQueue.main.async {
            self.buttonStack.arrangedSubviews.forEach { subview in
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
                    subview.transform = subview.transform.rotated(by: angle * .pi / 180)
                }
            }
        }
    }
    
    private func deviceOrientation(from deviceOrientation: UIDeviceOrientation) -> ViewModel.Orientation? {
        .init(rawValue: deviceOrientation.rawValue)
    }
}
