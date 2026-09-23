//
//  EditStorageLocationView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import SwiftUI

struct EditStorageLocationView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var storageLocationViewModel: StorageLocationViewModel

    let location: StorageLocation
    let onSave: (StorageLocation) -> Void

    @State private var name: String
    @State private var room: String
    @State private var notes: String
    @State private var showingUpdateConfirmation = false

    init(
        location: StorageLocation,
        storageLocationViewModel: StorageLocationViewModel,
        onSave: @escaping (StorageLocation) -> Void
    ) {
        self.location = location
        self.storageLocationViewModel = storageLocationViewModel
        self.onSave = onSave

        _name = State(initialValue: location.name)
        _room = State(initialValue: location.room ?? "")
        _notes = State(initialValue: location.notes ?? "")
    }
    
    private func saveLocation() {
        var updatedLocation = location
        updatedLocation.name = name
        updatedLocation.room = room.isEmpty ? nil : room
        updatedLocation.notes = notes.isEmpty ? nil : notes
        
        if storageLocationViewModel.updateStorageLocation(updatedLocation) {
            onSave(updatedLocation)
            dismiss()
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("Location Name", text: $name)
                TextField("Room", text: $room)

                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(3...5)
            }
        }
        .navigationTitle("Edit Location")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let locationChanged = name != location.name || room != (location.room ?? "")
                    
                    if locationChanged {
                        showingUpdateConfirmation = true
                    } else {
                        saveLocation()
                    }
                }
            }
        }
        .alert(
            "Unable to Update Location",
            isPresented: Binding(
                get: {
                    storageLocationViewModel.errorMessage != nil
                },
                set: { newValue in
                    if !newValue {
                        storageLocationViewModel.errorMessage = nil
                    }
                }
            )
        ) {
            Button("OK", role: .cancel) {
                storageLocationViewModel.errorMessage = nil
            }
        } message: {
            Text(storageLocationViewModel.errorMessage ?? "")
        }
        .alert("Update Storage Location?", isPresented: $showingUpdateConfirmation) {
            Button("Cancel", role: .cancel) {
                
            }
            Button("Update") {
                saveLocation()
            }
        } message: {
            Text("This location is used by stored medicines. Changes to the location name or room will also be reflected in those medicines.")
        }
    }
}

