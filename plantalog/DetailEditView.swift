//
//  DetailEditView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 8/6/23.
//

import SwiftUI

struct DetailEditView: View {
    @Binding var model: EntryModel
    @Binding var entry: PlantalogEntry
    @Binding var capturedImage: UIImage?
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        GeometryReader { screen in
            VStack (spacing: 0) {
                if let capturedImage = capturedImage {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screen.size.width, height: 0.4 * screen.size.height)
                } else {
                    Rectangle()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screen.size.width, height: 0.4 * screen.size.height)
                }
                NavigationStack {
                    Form {
                        Section (header: Text("Species Information")){
                            TextField("Species Name", text: $entry.species)
                            TextField("Notes", text: $entry.notes, axis: .vertical)
                                .lineLimit(3, reservesSpace: true)
                        }
                        .listRowBackground(Theme.rose.mainColor)
                        Section (header: Text("Discovery")) {
                            DatePicker(
                                "Date Discovered",
                                selection: $entry.dateDiscovered,
                                displayedComponents: [.date])
                            
                            TextField("Location Discovered", text: $entry.locationDiscovered)
                            
                        }
                        .listRowBackground(Theme.rose.mainColor)
                    }
                    .tint(Theme.forest.mainColor)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Cancel")
                                    .foregroundColor(Theme.asparagus.mainColor)
                            }
                        }
    
                        ToolbarItem(placement: .confirmationAction) {
                            Button(action: {
                                // TODO: check whether new entry is created or whether we're editing an existing entry
                                model.entries.append(entry)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Done")
                                    .foregroundColor(Theme.asparagus.mainColor)
                            }
                        }
                    }
                    .navigationBarTitle("Edit Entry")
                    .scrollContentBackground(.hidden)
                }
                .frame(width: screen.size.width, height: 0.6 * screen.size.height)
            }
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    @State static private var entry: PlantalogEntry = PlantalogEntry.emptyEntry
    @State static private var model: EntryModel = EntryModel()
    @State static private var capturedImage: UIImage? = UIImage(named:"tulip")
    
    init() {
        for entry in PlantalogEntry.sampleData {
            DetailEditView_Previews.model.entries.append(entry)
        }
    }
    
    
    
    static var previews: some View {
        DetailEditView(model: $model, entry: $entry, capturedImage: $capturedImage)
    }
}
