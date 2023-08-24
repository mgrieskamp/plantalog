//
//  ContentView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/26/23.
//

import SwiftUI

struct ContentView: View {
    @State private var searchImage: UIImage? = nil
    @State private var capturedImage: Image? = nil
    @State private var isCustomViewPresented = false
    @State private var isEditViewPresented = false
    @State private var entry: PlantalogEntry = PlantalogEntry.emptyEntry
    @StateObject var photoLibraryService = PhotoLibraryService()
    @EnvironmentObject var model: EntryModel
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: () -> Void
    
    
    var body: some View {
        ZStack {
            EntriesView()
            
            VStack {
                Spacer()
                Button(action: {
                    isCustomViewPresented.toggle()
                }, label: {
                    Image(systemName: "camera.fill")
                        .font(.largeTitle)
                        .padding()
                        .background(Theme.forest.mainColor)
                        .foregroundColor(Theme.forest.accentColor)
                        .clipShape(Circle())
                })
                .padding(.bottom)
                
                .sheet(isPresented: $isCustomViewPresented, content: { CustomCameraView(searchImage: $searchImage, capturedImage: $capturedImage, isEditViewPresented: $isEditViewPresented, entry: $entry)})
                
                .sheet(isPresented: $isEditViewPresented, onDismiss: {
                    photoLibraryService.fetchAllPhotos(assetsToFetch: model.photoIDs)
                    entry = PlantalogEntry.emptyEntry
                }){
                    ImageSearchView(entry: $entry, searchImage: $searchImage, capturedImage: $capturedImage, isEditViewPresented: $isEditViewPresented)
                }
                        
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
        .environmentObject(photoLibraryService)
        .environmentObject(model)
        
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(saveAction: {})
    }
}
