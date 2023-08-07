//
//  EntriesView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/30/23.
//

import SwiftUI

struct EntriesView: View {
    let entries: [PlantalogEntry]
    var body: some View {
        ZStack {
            Theme.asparagus.mainColor
            
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10), GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {
                        
                        ForEach(entries, id: \.species) { entry in
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
    }
}

struct EntriesView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesView(entries: PlantalogEntry.sampleData)
    }
}
