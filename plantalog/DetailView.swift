//
//  DetailView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 8/6/23.
//

import SwiftUI

struct DetailView: View {
    let entry: PlantalogEntry
    var body: some View {
        VStack {
            // TODO: fetch photo and display!
            List {
                Section(header: Text("Species Name")) {
                    Label {
                        Text("\(entry.species)")
                    } icon: {
                        Image(systemName: "leaf")
                            .foregroundColor(Theme.asparagus.mainColor)
                    }
                }
                Section(header: Text("Discovery")) {
                    Label {
                        Text(entry.dateDiscovered.formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                            .foregroundColor(Theme.asparagus.mainColor)
                    }
                    
                }
                Section(header: Label("Notes", systemImage: "note.text")) {
                    Text("\(entry.notes)")
                        .lineLimit(nil)
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(entry: PlantalogEntry.sampleData[0])
    }
}
