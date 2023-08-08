//
//  CameraView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/26/23.
//

import SwiftUI
import AVFoundation
import Photos

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    let cameraService: CameraService
    let didFinishProcessingPhoto: (Result<(AVCapturePhoto, String), Error>) -> ()
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        // start the camera service
        cameraService.start(delegate: context.coordinator) { err in
            if let err = err {
                didFinishProcessingPhoto(.failure(err))
                return
            }
        }
        
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(cameraService.previewLayer)
        cameraService.previewLayer.frame = viewController.view.bounds
        
        return viewController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, didFinishProcessingPhoto: didFinishProcessingPhoto)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        let parent: CameraView
        private var didFinishProcessingPhoto: (Result<(AVCapturePhoto, String), Error>) -> ()
        private var assetID: String?
        private var doneSaving: Bool = false
        
        init(_ parent: CameraView, didFinishProcessingPhoto: @escaping (Result<(AVCapturePhoto, String), Error>) -> ()) {
            self.parent = parent
            self.didFinishProcessingPhoto = didFinishProcessingPhoto
            self.assetID = nil
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                didFinishProcessingPhoto(.failure(error))
            }
            Task {
                await save(photo: photo) { [self] assetID in
                    if let assetID = assetID {
                        didFinishProcessingPhoto(.success((photo, assetID)))
                    } else {
                        didFinishProcessingPhoto(.failure(CameraError.NoAssetID))
                    }
                }
            }
        }
        
        func save(photo: AVCapturePhoto, completion: @escaping (String?) -> Void ) async {
            doneSaving = false
            if let photoData = photo.fileDataRepresentation() {
                PHPhotoLibrary.shared().performChanges {
                    // save photo
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: photoData, options: nil)
                    self.assetID = creationRequest.placeholderForCreatedAsset?.localIdentifier ?? nil
                    completion(self.assetID)
                    
                } completionHandler: { success, error in
                    if let error {
                        print("Error saving photo: \(error.localizedDescription)")
                        return
                    }
                    
                }
            }
        }
        
        
    }
}

enum CameraError: Error {
    case NoAssetID
}
