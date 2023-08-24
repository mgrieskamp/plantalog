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
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var photoLibraryService: PhotoLibraryService
    @EnvironmentObject var model: EntryModel
    @State var image: Image?
    @State var isEditViewPresented: Bool = false
    @State var isDeletePresented: Bool = false
    @Binding var entry: PlantalogEntry
    
    // need a state variable here or else changes in DetailEditView do not reflect in DetailView
    @State var displayedEntry: PlantalogEntry
    
    var body: some View {
        GeometryReader { screen in
            VStack (spacing: 0) {
                
                if let image = image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screen.size.width, height: screen.size.width)
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
                                Text("\(displayedEntry.species)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .textCase(nil)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        , content: {})
                        
                        Section(header: Text("Discovery")) {
                            Label {
                                Text(displayedEntry.dateDiscovered.formatted(date: .long, time: .omitted))
                            } icon: {
                                Image(systemName: "calendar")
                                    .foregroundColor(Theme.asparagus.mainColor)
                            }
                            
                            Label {
                                Text(displayedEntry.locationDiscovered)
                            } icon: {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(Theme.asparagus.mainColor)
                            }
                            
                        }
                        Section(header: Label("Notes", systemImage: "note.text")) {
                            Text("\(displayedEntry.notes)")
                                .lineLimit(nil)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isEditViewPresented = true
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                    .aspectRatio(contentMode: .fill)
                                    .font(.system(size: 24))
                                    .foregroundColor(Theme.asparagus.mainColor)
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isDeletePresented = true
                                presentationMode.wrappedValue.dismiss()
                                
                            }) {
                                Image(systemName: "trash.circle.fill")
                                    .aspectRatio(contentMode: .fill)
                                    .font(.system(size: 24))
                                    .foregroundColor(Theme.asparagus.mainColor)
                            }
                        }
                    }
                    .sheet(isPresented: $isEditViewPresented, onDismiss: {
                        // update model's entry
                        entry = displayedEntry
                    }) {
                        DetailEditView(entry: $displayedEntry, capturedImage: $image, isEditViewPresented: $isEditViewPresented, isNewEntry: false, editedEntry: $entry.wrappedValue)
                    }
                    .actionSheet(isPresented: $isDeletePresented) {
                        ActionSheet(title: Text("Delete Entry"),
                                    message: Text("Are you sure you want to delete this entry? This action cannot be undone."),
                                    buttons: [
                                        .cancel(),
                                        .destructive(
                                            Text("Delete entry"),
                                            action: {
                                                if let index = model.entries.firstIndex(where: { $0.id == entry.id }) {
                                                    model.entries.remove(at: index)
                                                }
                                            })])
                    }
                }
                .task {
                    if displayedEntry.photoID != nil {
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
        DetailView(entry: .constant(PlantalogEntry.sampleData[0]), displayedEntry: PlantalogEntry.sampleData[0])
    }
}
