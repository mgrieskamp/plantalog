//
//  CustomCameraView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/27/23.
//

import SwiftUI

struct CustomCameraView: View {
    
    let cameraService = CameraService()
    @Binding var searchImage: UIImage?
    @Binding var capturedImage: Image?
    @Binding var isEditViewPresented: Bool
    @Binding var entry: PlantalogEntry
    
    @Environment(\.presentationMode) private var presentationMode
    
    
    var body: some View {
        ZStack {
            CameraView(cameraService: cameraService) { result in
                switch result {
                case .success(let (photo, assetID)):
                    if let data = photo.fileDataRepresentation() {
                        if let uiImage = UIImage(data: data) {
                            searchImage = uiImage
                            capturedImage = Image(uiImage: uiImage)
                        }
                        entry.photoID = assetID
                        presentationMode.wrappedValue.dismiss()
                        isEditViewPresented.toggle()
                    } else {
                        print("Error: No image data found")
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            
            VStack {
                Spacer()
                Button(action: {
                    if cameraService.checkPermissions() {
                        cameraService.capturePhoto()
                    } else {
                        // TODO: make pop-up to ask users to change permissions in settings
                    }
                }, label: {
                    Image(systemName: "circle")
                        .font(.system(size: 72))
                        .foregroundColor(.white)
                        .padding(.bottom)
                })
            }
        }
    }
}
