//
//  StorageLocationListView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import SwiftUI

struct StorageLocationListView: View {
    
    @StateObject private var storageLocationViewModel: StorageLocationViewModel
    @State private var showingAddLocation = false
    
    init() {
        let repository = JSONStorageLocationRepository()
        let getStorageLocationUseCase = GetStorageLocationsUseCase(repository: repository)
        let addStorageLocationUseCase = AddStorageLocationUseCase(repository: repository)
        
        _storageLocationViewModel = StateObject(wrappedValue: StorageLocationViewModel(getStorageLocationsUseCase: getStorageLocationUseCase, addStorageLocationUseCase: addStorageLocationUseCase))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if storageLocationViewModel.storageLocations.isEmpty {
                    ContentUnavailableView("No Storage Locations", systemImage: "cabinet", description: Text("Add a location to organise your medicines."))
                } else {
                    List(storageLocationViewModel.storageLocations) { location in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(location.name)
                                .font(.headline)
                            
                            if let room = location.room, !room.isEmpty {
                                Text(room)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Storage Locations")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddLocation = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                storageLocationViewModel.loadStorageLocations()
            }
        }
        .sheet(isPresented: $showingAddLocation) {
            AddStorageLocationView(
                storageLocationViewModel: storageLocationViewModel
            )
        }
    }
}

#Preview {
    StorageLocationListView()
}
