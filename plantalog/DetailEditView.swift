//
//  DetailEditView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 8/6/23.
//

import SwiftUI

struct DetailEditView: View {
    @EnvironmentObject var model: EntryModel
    @Binding var entry: PlantalogEntry
    @Binding var capturedImage: Image?
    @Binding var isEditViewPresented: Bool
    var isNewEntry: Bool
    @State var editedEntry: PlantalogEntry
    
    @Environment(\.presentationMode) private var presentationMode
    
//    init(entry: Binding<PlantalogEntry>, capturedImage: Binding<Image?>, isEditViewPresented: Binding<Bool>, isNewEntry: Bool) {
//        _entry = entry
//        _capturedImage = capturedImage
//        _isEditViewPresented = isEditViewPresented
//        self.isNewEntry = isNewEntry
//
//
//    }
    
    var body: some View {
        GeometryReader { screen in
            ScrollView {
                VStack (spacing: 0) {
                    if let capturedImage = capturedImage {
                        capturedImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: screen.size.width, height: screen.size.width)
                            .clipped()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Rectangle()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: screen.size.width, height: screen.size.width)
                            .foregroundColor(.gray)
                    }
                    NavigationStack {
                        Form {
                            Section (header: Text("Species Information")){
                                TextField("Species Name", text: $editedEntry.species)
                                TextField("Notes", text: $editedEntry.notes, axis: .vertical)
                                    .lineLimit(3, reservesSpace: true)
                            }
                            .listRowBackground(Theme.rose.mainColor)
                            Section (header: Text("Discovery")) {
                                DatePicker(
                                    "Date Discovered",
                                    selection: $editedEntry.dateDiscovered,
                                    displayedComponents: [.date])
                                
                                TextField("Location Discovered", text: $editedEntry.locationDiscovered)
                                
                            }
                            .listRowBackground(Theme.rose.mainColor)
                        }
                        .tint(Theme.forest.mainColor)
                        .scrollContentBackground(.hidden)
                        .navigationBarTitle("Edit Entry")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button(action: {
                                    isEditViewPresented = false
                                }) {
                                    Text("Cancel")
                                        .foregroundColor(Theme.asparagus.mainColor)
                                }
                            }
                            
                            ToolbarItem(placement: .confirmationAction) {
                                Button(action: {
                                    // TODO: check whether new entry is created or whether we're editing an existing entry
                                    
                                    entry = editedEntry
                                    
                                    model.entries.append(entry)
                                    isEditViewPresented = false
                                }) {
                                    Text("Done")
                                        .foregroundColor(Theme.asparagus.mainColor)
                                }
                            }
                        }
                    }
                    .frame(width: screen.size.width, height: 0.6 * screen.size.height)
                }
            }
        }
        .onAppear {
            self.editedEntry = $entry.wrappedValue
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    @State static private var entry: PlantalogEntry = PlantalogEntry.emptyEntry
    @State static private var model: EntryModel = EntryModel()
    @State static private var capturedImage: Image? = Image("tulip")
    
    init() {
        for entry in PlantalogEntry.sampleData {
            DetailEditView_Previews.model.entries.append(entry)
        }
    }
    
    
    
    static var previews: some View {
        DetailEditView(entry: $entry, capturedImage: $capturedImage, isEditViewPresented: .constant(true), isNewEntry: true, editedEntry: $entry.wrappedValue)
    }
}
