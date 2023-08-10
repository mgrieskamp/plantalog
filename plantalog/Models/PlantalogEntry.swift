//
//  PlantalogEntry.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/28/23.
//

import Foundation
import SwiftUI

struct PlantalogEntry {
    // let id: UUID
    var photoID: String?   // local identifier
    var species: String
    var dateDiscovered: Date
    var locationDiscovered: String
    var notes: String
    
    init(photoID: String?, species: String, dateDiscovered: Date, locationDiscovered: String, notes: String) {
        self.photoID = photoID
        self.species = species
        self.dateDiscovered = dateDiscovered
        self.locationDiscovered = locationDiscovered
        self.notes = notes
    }
}


extension PlantalogEntry {
    static var emptyEntry: PlantalogEntry {
        PlantalogEntry(photoID: nil, species: "", dateDiscovered: Date(), locationDiscovered: "", notes: "")
    }
    
    
    static let sampleData: [PlantalogEntry] =
    [
        PlantalogEntry(photoID: nil,
                       species: "Malus domestica",
                       dateDiscovered: Date(),
                       locationDiscovered: "Snoqualmie", notes: "ate an apple from this tree. seemed to be a granny smith apple, it was green and quite sour. kept a few seeds, maybe try to plant them soon!"),
        PlantalogEntry(photoID: nil,
                       species: "Monstera deliciosa",
                       dateDiscovered: Date(),
                       locationDiscovered: "The Plant Shop",
                       notes: "water every week"),
        PlantalogEntry(photoID: nil,
                       species: "Tulipa gesneriana",
                       dateDiscovered: Date(),
                       locationDiscovered: "Fred Meyer's",
                       notes: "some tulips")
    ]
}

class EntryModel: ObservableObject {
    
    @Published var entries: [PlantalogEntry] = []
    var numEntries: Int { entries.count }
    var photoIDs: [String] { entries.map(\.photoID ).filter( {$0 != nil} ).map({$0!}) }
    var species: [String] { entries.map(\.species) }
    var dates: [Date] { entries.map(\.dateDiscovered) }
    var locations: [String] { entries.map(\.locationDiscovered) }
    
}
