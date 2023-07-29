//
//  PlantalogEntry.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/28/23.
//

import Foundation
import SwiftUI

struct PlantalogEntry {
    var photo: Image
    var species: String
    var dateDiscovered: Date
    var locationDiscovered: String
    var notes: String
}


extension PlantalogEntry {
    static let sampleData: [PlantalogEntry] =
    [
        PlantalogEntry(photo: Image(systemName: "tree.fill"),
                       species: "Malus domestica",
                       dateDiscovered: Date(),
                       locationDiscovered: "Snoqualmie", notes: "ate an apple from this tree"),
        PlantalogEntry(photo: Image(systemName: "leaf.fill"),
                       species: "Monstera deliciosa",
                       dateDiscovered: Date(),
                       locationDiscovered: "The Plant Shop",
                       notes: "water every week"),
        PlantalogEntry(photo: Image(systemName: "camera.macro"),
                       species: "Tulipa gesneriana",
                       dateDiscovered: Date(),
                       locationDiscovered: "Fred Meyer's",
                       notes: "a tulip")
    ]
}
