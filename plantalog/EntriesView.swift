//
//  EntriesView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/30/23.
//

import SwiftUI

struct EntriesView: View {
    @EnvironmentObject var photoLibraryService: PhotoLibraryService
    @State private var showErrorPrompt = false
    @EnvironmentObject var model: EntryModel
    
    var body: some View {
        ZStack {
            Theme.asparagus.mainColor
            
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10), GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {
                        
                        ForEach($model.entries, id: \.species) { entry in
                            NavigationLink(destination: DetailView(entry: entry)) {
                                CardView(entry: entry)
                            }
                            .scaledToFit()
                            .cornerRadius(15)
                        }
                    }
                    .padding()
                    .navigationTitle("Plantalog")
                }
            }
        }
        .onAppear {
            requestForAuthorizationIfNecessary()
            photoLibraryService.fetchAllPhotos(assetsToFetch: model.photoIDs)
        }
        .alert(Text("This app requires photo library access to show your photos"),
               isPresented: $showErrorPrompt
        ) {}
    }
}

extension EntriesView{
    func requestForAuthorizationIfNecessary() {
        guard photoLibraryService.authorizationStatus != .authorized || photoLibraryService.authorizationStatus != .limited
        else { return }
        photoLibraryService.requestAuthorization { error in
            guard error != nil else { return }
            showErrorPrompt = true
        }
    }
}

struct EntriesView_Previews: PreviewProvider {
    @StateObject static private var model: EntryModel = EntryModel()
    
    init() {
        for entry in PlantalogEntry.sampleData {
            EntriesView_Previews.model.entries.append(entry)
        }
    }
    static var previews: some View {
        EntriesView()
            .environmentObject(model)
    }
}
