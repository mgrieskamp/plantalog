//
//  DetailEditView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 8/6/23.
//

import SwiftUI

struct DetailEditView: View {
    @Binding var entries: [PlantalogEntry]
    @Binding var entry: PlantalogEntry
    var capturedImage: UIImage
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        GeometryReader { screen in
            VStack (spacing: 0) {
                Image(uiImage: capturedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screen.size.width, height: 0.4 * screen.size.height)
                
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
                                entries.append(entry)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Done")
                                    .foregroundColor(Theme.asparagus.mainColor)
                            }
                        }
                    }
                    .navigationBarTitle(Text("Edit Entry").font(.headline))
                    .scrollContentBackground(.hidden)
                }
                .frame(width: screen.size.width, height: 0.6 * screen.size.height)
            }
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    @State static private var entry: PlantalogEntry = PlantalogEntry.emptyEntry
    @State static private var entries: [PlantalogEntry] = PlantalogEntry.sampleData
    static var previews: some View {
        DetailEditView(entries: $entries, entry: $entry, capturedImage: UIImage(named:"tulip")!)
    }
}
