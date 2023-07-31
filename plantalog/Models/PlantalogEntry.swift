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
    var photo: Image
    var species: String
    var dateDiscovered: Date
    var locationDiscovered: String
    var notes: String
    
    init(photo: Image, species: String, dateDiscovered: Date, locationDiscovered: String, notes: String) {
        self.photo = photo
        self.species = species
        self.dateDiscovered = dateDiscovered
        self.locationDiscovered = locationDiscovered
        self.notes = notes
    }
}


extension PlantalogEntry {
    static let sampleData: [PlantalogEntry] =
    [
        PlantalogEntry(photo: Image("apple-tree"),
                       species: "Malus domestica",
                       dateDiscovered: Date(),
                       locationDiscovered: "Snoqualmie", notes: "ate an apple from this tree"),
        PlantalogEntry(photo: Image("monstera"),
                       species: "Monstera deliciosa",
                       dateDiscovered: Date(),
                       locationDiscovered: "The Plant Shop",
                       notes: "water every week"),
        PlantalogEntry(photo: Image("tulip"),
                       species: "Tulipa gesneriana",
                       dateDiscovered: Date(),
                       locationDiscovered: "Fred Meyer's",
                       notes: "some tulips")
    ]
}
