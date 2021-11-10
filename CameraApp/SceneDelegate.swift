//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit
import AVFoundation

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private lazy var cameraControlStateMachine = CameraControlStateMachine()
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        switch cameraControlStateMachine.changeRatioButtonState {
        case .sixteenByNine: session.sessionPreset = .hd1280x720
        case .fourByThree: session.sessionPreset = .photo
        }
        
        return session
    }()
    
    private lazy var sessionConfigurator = SessionConfigurator(captureSession: captureSession)
    private lazy var cameraManager = CameraManager(sessionConfigurator, LibraryPhotoSaver())
    private let previewView = PreviewView()
    private lazy var cameraAdapter = CameraManagerAdapter(cameraManager, previewView)
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let onViewDidLoad = { [unowned self] in
            PermissionsManager().requestPermissions(isGrantedCompletion: sessionConfigurator.configure)
        }
        
        let cameraVC = makeCameraVC(previewView, captureSession, onViewDidLoad)
        let cameraControlVC = makeCameraControlVC(cameraControlStateMachine)
        cameraControlVC.cameraControlVM.delegate = cameraAdapter
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainContainerVC(cameraVC: cameraVC, cameraControlVC: cameraControlVC)
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func makeCameraVC(
        _ previewView: PreviewView,
        _ captureSession: AVCaptureSession,
        _ onViewDidLoad: @escaping (() -> Void))
    -> UIViewController {
        previewView.videoLayer.session = captureSession
        let vc = CameraVC(previewView)
        vc.onViewDidLoad = onViewDidLoad
        vc.onViewDidLayoutSubviews = {
            if let connection = previewView.videoLayer.connection  {
                let deviceOrientation = UIDevice.current.orientation
                if connection.isVideoOrientationSupported,
                   let videoOrientation = AVCaptureVideoOrientation(rawValue: deviceOrientation.rawValue) {
                    connection.videoOrientation = videoOrientation
                }
            }
        }
        
        return vc
    }
    
    private func makeCameraControlVC(_ stateMachine: CameraControlStateMachine) -> CameraControlVC {
        CameraControlVC(cameraControlView: .init(), cameraControlVM: .init(stateMachine, .init()))
    }
}
