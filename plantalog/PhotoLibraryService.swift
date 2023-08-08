//
//  PhotoLibraryService.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 8/7/23.
//

// Tutorial from https://codewithchris.com/photo-gallery-app-swiftui-part-1/


import Foundation
import Photos
import UIKit

class PhotoLibraryService: ObservableObject {
    
    @Published var results = PHFetchResultCollection(fetchResult: .init())
    var authorizationStatus: PHAuthorizationStatus = .notDetermined
    var imageCachingManager = PHCachingImageManager()

    

    func requestAuthorization(handleError: ((Error?) -> Void)? = nil) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                self?.authorizationStatus = status
                switch status {
                case .authorized, .limited:
                    break
                case .denied, .notDetermined, .restricted:
                    handleError?(QueryError.restrictedAccess)
                @unknown default:
                    break
                }
            }
        }
    
    
    // fetches photos of all entries only given the entries' local identifiers
    func fetchAllPhotos(assetsToFetch: [String]) {
        imageCachingManager.allowsCachingHighQualityImages = false
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeHiddenAssets = false
        DispatchQueue.main.async {
            self.results.fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetsToFetch, options: fetchOptions)
        }
    }
    
    
    func fetchImage(localID: String, targetSize: CGSize = PHImageManagerMaximumSize, contentMode: PHImageContentMode = .default) async throws -> UIImage? {
        
        let results = PHAsset.fetchAssets(withLocalIdentifiers: [localID],options: nil)
        guard let asset = results.firstObject else {
            throw QueryError.phAssetNotFound
        }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            // Use the imageCachingManager to fetch the image
            self?.imageCachingManager.requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: { image, info in
                    // image is of type UIImage
                    if let error = info?[PHImageErrorKey] as? Error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume(returning: image)
                }
            )
        }
    }
}


enum QueryError: Error {
    case phAssetNotFound
    case restrictedAccess
}


// create a random access collection for indexing and ForEach support
struct PHFetchResultCollection: RandomAccessCollection, Equatable {

    typealias Element = PHAsset
    typealias Index = Int

    var fetchResult: PHFetchResult<PHAsset>

    var endIndex: Int { fetchResult.count }
    var startIndex: Int { 0 }

    subscript(position: Int) -> PHAsset {
        fetchResult.object(at: fetchResult.count - position - 1)
    }
}
