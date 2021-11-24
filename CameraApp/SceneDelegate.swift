//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import UIKit
import AVFoundation
import Rotations

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
    private lazy var cameraAdapter = CameraManagerAdapter(cameraManager)
    private lazy var rotationManager = RotationManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let cameraControlView = CameraControlView()
        let cameraControlVC = makeCameraControlVC(cameraControlView, cameraControlStateMachine)
        cameraControlVC.cameraControlVM.delegate = cameraAdapter
        
        let rotationDelegate = RotationManagerDelegateComposite([cameraControlView, cameraAdapter])
        
        let onViewDidLoad = { [unowned self] in
            PermissionsManager().requestPermissions(isGrantedCompletion: sessionConfigurator.configure)
            rotationManager.startRotationManagerUpdates(rotationDelegate)
        }
        
        let cameraVC = makeCameraVC(captureSession, onViewDidLoad)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainContainerVC(cameraVC: cameraVC, cameraControlVC: cameraControlVC)
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func makeCameraVC(
        _ captureSession: AVCaptureSession,
        _ onViewDidLoad: @escaping (() -> Void))
    -> UIViewController {
        let previewView = PreviewView()
        previewView.videoLayer.session = captureSession
        let vc = CameraVC(previewView)
        vc.onViewDidLoad = onViewDidLoad
        
        return vc
    }
    
    private func makeCameraControlVC(_ cameraControlView: CameraControlView, _ stateMachine: CameraControlStateMachine) -> CameraControlVC {
        CameraControlVC(cameraControlView: cameraControlView, cameraControlVM: .init(stateMachine, .init()))
    }
}
