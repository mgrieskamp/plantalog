//
//  VisionAPIWebDetection.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 8/19/23.
//

import Foundation
import Alamofire
import SwiftUI

class VisionAPIWebDetection {
    private let apiKey = ""     // replace with key when using
    private var apiURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
    }
    
    func detect(image: UIImage, completion: @escaping (WebResult?) -> Void) {
        guard let encodedImage = encodeImage(image: image) else {
            print("Error while base64 encoding image")
            completion(nil)
            return
        }
        callVisionAPI(encodedImage: encodedImage, completion: completion)
    }
    
    private func callVisionAPI(encodedImage: String, completion: @escaping (WebResult?) -> Void) {
        let parameters: Parameters = [
            "requests": [
                [
                    "image": [
                        "content": encodedImage
                    ],
                    "features": [
                        [
                            "type": "LABEL_DETECTION"
                        ]
                    ]
                ] as [String : Any]
            ]
        ]
        let headers: HTTPHeaders = [
              "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? "",
        ]
        AF.request(
              apiURL,
              method: .post,
              parameters: parameters,
              encoding: JSONEncoding.default,
              headers: headers)
            .responseData { response in
                switch response.result {
                case .failure(_):
                    completion(nil)
                    return
                case .success(let data):
                    let webDetectionResponse = try? JSONDecoder().decode(VisionAPIWebDetectionResponse.self, from: data)
                    completion(webDetectionResponse?.responses[0])
                }
            }
                
    }
    
    private func encodeImage(image: UIImage) -> String? {
        return image.pngData()?.base64EncodedString(options: .endLineWithCarriageReturn)
    }
}
