//
//  PlantalogEntry.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/28/23.
//

import Foundation
import SwiftUI

struct PlantalogEntry: Codable {
    let id: UUID
    var photoID: String?   // local identifier
    var species: String
    var dateDiscovered: Date
    var locationDiscovered: String
    var notes: String
    
    init(id: UUID = UUID(), photoID: String?, species: String, dateDiscovered: Date, locationDiscovered: String, notes: String) {
        self.id = id
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
    
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: false)
        .appendingPathComponent("entries.data")
    }
    
    func load() async throws {
        let task = Task<[PlantalogEntry], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else { return [] }
            let entries = try JSONDecoder().decode([PlantalogEntry].self, from: data)
            return entries
        }
        let entries = try await task.value
        self.entries = entries
        
    }
    
    func save(entries: [PlantalogEntry]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(entries)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
}
