//
//  ContentView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/26/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var capturedImage: UIImage? = nil
    @State private var isCustomViewPresented = false
    @State private var isEditViewPresented = false
    @State private var entry: PlantalogEntry = PlantalogEntry.emptyEntry
    @State private var entries: [PlantalogEntry] = []
    
    
    var body: some View {
        ZStack {
            EntriesView(entries: PlantalogEntry.sampleData)
            
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
                
                .sheet(isPresented: $isEditViewPresented, content: { DetailEditView(entries: $entries, entry: $entry, capturedImage: capturedImage!)})
                        
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
