//
//  DetailView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 8/6/23.
//

import SwiftUI
import Photos

struct DetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var photoLibraryService: PhotoLibraryService
    @State var image: Image?
    @State var isEditViewPresented: Bool = false
    @Binding var entry: PlantalogEntry
    var body: some View {
        GeometryReader { screen in
            VStack (spacing: 0) {
                
                if let image = image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screen.size.width, height: screen.size.width, alignment: .top)
                        .clipped()
                        .aspectRatio(contentMode: .fit)
                } else {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(width: screen.size.width, height: screen.size.width, alignment: .top)
                            .aspectRatio(contentMode: .fit)
                        ProgressView()
                    }
                    
                }
                    
                
                NavigationStack {
                    List {
                        Section(header:
                            HStack {
                                Image(systemName: "leaf")
                                    .font(.headline)
                                    .foregroundColor(Theme.asparagus.mainColor)
                                    .padding(.trailing, 5)
                                Text("\(entry.species)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .textCase(nil)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        , content: {})
                        
                        Section(header: Text("Discovery")) {
                            Label {
                                Text(entry.dateDiscovered.formatted(date: .long, time: .omitted))
                            } icon: {
                                Image(systemName: "calendar")
                                    .foregroundColor(Theme.asparagus.mainColor)
                            }
                            
                            Label {
                                Text(entry.locationDiscovered)
                            } icon: {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(Theme.asparagus.mainColor)
                            }
                            
                        }
                        Section(header: Label("Notes", systemImage: "note.text")) {
                            Text("\(entry.notes)")
                                .lineLimit(nil)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                        
                            Button(action: {
                                isEditViewPresented = true
                            }) {
                                Text("Edit")
                                    .foregroundColor(Theme.asparagus.mainColor)
                            }
                            .sheet(isPresented: $isEditViewPresented) {
                                DetailEditView(entry: $entry, capturedImage: $image, isEditViewPresented: $isEditViewPresented, isNewEntry: false, editedEntry: $entry.wrappedValue)
                            }
                        }
                    }
                }
                .task {
                    if entry.photoID != nil {
                        await loadImageAsset()
                    }
                }
            }
        }
    }
}

extension DetailView {
    func loadImageAsset(
        targetSize: CGSize = PHImageManagerMaximumSize
    ) async {
            guard let uiImage = try? await photoLibraryService
            .fetchImage(
                localID: self.entry.photoID!,
                targetSize: targetSize
            ) else {
                image = nil
                return
            }
        image = Image(uiImage: uiImage)
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(entry: .constant(PlantalogEntry.sampleData[0]))
    }
}
