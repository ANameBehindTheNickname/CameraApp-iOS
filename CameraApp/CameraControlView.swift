//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit

final class CameraControlView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet var buttonStack: UIStackView!
    
    @IBOutlet private var gridButton: UIButton!
    @IBOutlet private var changeCameraButton: UIButton!
    @IBOutlet private var takePhotoButton: UIButton!
    @IBOutlet private var changeRatioButton: UIButton!
    @IBOutlet private var flashlightButton: UIButton!
    
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
        styleButtons()
    }
    
    private func styleButtons() {
        let buttons = [gridButton, changeCameraButton, takePhotoButton, changeRatioButton, flashlightButton]
        let symbols = ["rectangle.split.3x3", "arrow.triangle.2.circlepath.camera", "largecircle.fill.circle", "aspectratio", "bolt.badge.a"]
        zip(buttons, symbols).forEach { button, symbol in
            let image = UIImage(systemName: symbol)?.withWhiteTintColor()
            button?.setImage(image, for: .normal)
        }
        
        takePhotoButton.setPreferredSymbolConfiguration(.init(pointSize: 55), forImageIn: .normal)
    }
}
