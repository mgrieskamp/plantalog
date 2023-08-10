//
//  ContentView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/26/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var capturedImage: Image? = nil
    @State private var isCustomViewPresented = false
    @State private var isEditViewPresented = false
    @State private var entry: PlantalogEntry = PlantalogEntry.emptyEntry
    @StateObject private var model: EntryModel = .init()
    
    @StateObject var photoLibraryService = PhotoLibraryService()
    
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
                
                .sheet(isPresented: $isCustomViewPresented, content: { CustomCameraView(capturedImage: $capturedImage, isEditViewPresented: $isEditViewPresented, entry: $entry)})
                
                .sheet(isPresented: $isEditViewPresented, onDismiss: {
                    photoLibraryService.fetchAllPhotos(assetsToFetch: model.photoIDs)
                    entry = PlantalogEntry.emptyEntry
                }){
                    DetailEditView(entry: $entry, capturedImage: $capturedImage, isEditViewPresented: $isEditViewPresented, isNewEntry: true, editedEntry: $entry.wrappedValue)
                }
                        
            }
        }
        .environmentObject(photoLibraryService)
        .environmentObject(model)
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
