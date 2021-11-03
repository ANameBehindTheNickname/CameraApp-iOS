//
//
//  Copyright © 2021 ANameBehindTheNickname. All rights reserved.
//

import Photos

final class LibraryPhotoSaver: NSObject, PhotoSaver {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            return print("Error capturing photo: \(error!)")
        }

        switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
        case .authorized:

            guard let photoData = photo.fileDataRepresentation() else { return }

            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: photoData, options: nil)
            } completionHandler: { _, _ in }

        case .notDetermined: return
        case .restricted, .denied, .limited: return
        @unknown default: return
        }
    }
}
