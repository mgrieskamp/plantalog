//
//  CameraService.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/26/23.
//

import Foundation
import AVFoundation
import Photos

public class CameraService {
    
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping
    (Error?) -> ()) {
        self.delegate = delegate
        if checkPermissions() {
            setUpCamera(completion: completion)
        }
        
    }
    
    func checkPermissions() -> Bool {
        let captureStatus = AVCaptureDevice.authorizationStatus(for: .video)
        // check for authorization
        var captureAuthorized = captureStatus == .authorized
        // if not determined yet, request for access
        if captureStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                captureAuthorized = granted
            }
        }
        
        // if capture is authorized, ask for library access
        if captureAuthorized {
            let libStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            var libAuthorized = libStatus == .authorized || libStatus == .limited
            if libStatus == .notDetermined {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    libAuthorized = status == .authorized || status == .limited
                }
            }
            return captureAuthorized && libAuthorized
        } else {
            return false
        }
    }
    
//    private func checkPermissions(completion: @escaping (Error?) -> ()) {
//        // check permission to take photos
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                // if did not get permission, do not move on to next check
//                guard granted else { return }
//            }
//        case .restricted:
//            return
//        case .denied:
//            return
//        case .authorized:
//            // move on to next check
//            break
//        @unknown default:
//            return
//        }
//
//        // check permission to save and access photos
//        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
//        case .notDetermined:
//            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
//                guard (status == .authorized) else { return }
//                // all permissions granted, set up camera
//                DispatchQueue.main.async {
//                    self?.setUpCamera(completion: completion)
//                }
//            }
//        case .restricted:
//            break
//        case .denied:
//            break
//        case .authorized:
//            setUpCamera(completion: completion)
//        case .limited:
//            setUpCamera(completion: completion)
//        @unknown default:
//            break
//        }
//    }
    
    private func setUpCamera(completion: @escaping (Error?) -> ()) {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            } catch {
                completion(error)
            }
        }
    }
    
    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        output.capturePhoto(with: settings, delegate: delegate!)
    }
}
