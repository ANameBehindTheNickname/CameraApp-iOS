//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit
import CoreMotion

final class DeviceRotationManager {
    private let motionManager: CMMotionManager
    private let operationQueue: OperationQueue
    private let accelerometerUpdateInterval = 0.1
    private var currentOrientation = UIDeviceOrientation.unknown
    
    weak var delegate: DeviceRotationDelegate?
    
    init(_ motionManager: CMMotionManager, _ operationQueue: OperationQueue) {
        self.motionManager = motionManager
        self.operationQueue = operationQueue
        configureMotionManager()
    }
    
    private func configureMotionManager() {
        motionManager.accelerometerUpdateInterval = accelerometerUpdateInterval
        
        motionManager.startAccelerometerUpdates(to: operationQueue) { [weak self] data, error in
            guard let data = data, error == nil else { return }
            
            self?.convertAccelerationData(data.acceleration)
        }
    }
    
    private func convertAccelerationData(_ acceleration: CMAcceleration) {
        var newDeviceOrientation = currentOrientation
        if acceleration.x >= 0.75 {
            newDeviceOrientation = .landscapeLeft
        } else if acceleration.x <= -0.75 {
            newDeviceOrientation = .landscapeRight
        } else if acceleration.y <= -0.75 {
            newDeviceOrientation = .portrait
        } else if acceleration.y >= 0.75 {
            newDeviceOrientation = .portraitUpsideDown
        }

        if newDeviceOrientation != currentOrientation {
            delegate?.deviceDidRotate(to: newDeviceOrientation)
            currentOrientation = newDeviceOrientation
        } else if newDeviceOrientation == .unknown {
            delegate?.deviceDidRotate(to: .portrait)
        }
    }
}
