//
//  AddStorageLocationView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import SwiftUI

struct AddStorageLocationView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var storageLocationViewModel: StorageLocationViewModel
    
    @State private var name = ""
    @State private var room = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Location Name", text: $name)
                    TextField("Room", text: $room)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .navigationTitle("Add Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let location = StorageLocation(id: UUID(), name: name, room: room.isEmpty ? nil : room, notes: notes.isEmpty ? nil : notes, createdAt: Date())
                        
                        if storageLocationViewModel.addStorageLocation(location) {
                            dismiss()
                        }
                    }
                }
            }
        }
        .alert(
            "Unable to Add Location",
            isPresented: Binding(
                get: { storageLocationViewModel.errorMessage != nil },
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
    }
}

