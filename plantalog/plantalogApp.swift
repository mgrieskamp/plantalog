//
//  plantalogApp.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/26/23.
//

import SwiftUI

@main
struct plantalogApp: App {
    @StateObject private var model: EntryModel = .init()
    var body: some Scene {
        WindowGroup {
            ContentView() {
                Task {
                    do {
                        try await model.save(entries: model.entries)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
                .environmentObject(model)
                .task {
                    do {
                        try await model.load()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
        }
    }
}
