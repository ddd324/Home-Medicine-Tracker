//
//  StorageLocationDetailView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import SwiftUI

struct StorageLocationDetailView: View {
    
    @ObservedObject var storageLocationViewModel: StorageLocationViewModel
    
    @State private var location: StorageLocation
    
    init(storageLocationViewModel: StorageLocationViewModel, location: StorageLocation) {
        self.storageLocationViewModel = storageLocationViewModel
        _location = State(initialValue: location)
    }

    var body: some View {
        List {
            Section("Location Information") {
                LabeledContent("Location Name", value: location.name)

                if let room = location.room,
                   !room.isEmpty {
                    LabeledContent("Room", value: room)
                }

                if let notes = location.notes,
                   !notes.isEmpty {
                    LabeledContent("Notes", value: notes)
                }
            }

            Section("Medicines") {
                Text("No medicines in this location.")
                    .foregroundStyle(.secondary)
            }

            Section {
                Button("Add Medicine Here") {
                    // Connect later
                }
            }
        }
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("Edit") {
                    EditStorageLocationView(location: location, storageLocationViewModel: storageLocationViewModel) { updatedLocation in
                        location = updatedLocation
                    }
                }
            }
        }
    }
}

