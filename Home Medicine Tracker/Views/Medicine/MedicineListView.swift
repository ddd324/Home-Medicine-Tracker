//
//  MedicineListView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import SwiftUI

struct MedicineListView: View {
    
    @State private var showingAddMedicine = false
    @StateObject private var medicineViewModel: MedicineViewModel
    
    init(repository: MedicineRepository) {
        let getMedicinesUseCase = GetMedicinesUseCase(repository: repository)
        let addMedicineUseCase = AddMedicineUseCase(repository: repository)
        let updateMedicineUseCase = UpdateMedicineUseCase(repository: repository)
        let markMedicineAsReturnedUseCase = MarkMedicineAsReturnedUseCase(repository: repository)
        
        _medicineViewModel = StateObject(wrappedValue: MedicineViewModel(getMedicinesUseCase: getMedicinesUseCase, addMedicineUseCase: addMedicineUseCase, updateMedicineUseCase: updateMedicineUseCase, markMedicineAsReturnedUseCase: markMedicineAsReturnedUseCase))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if medicineViewModel.medicines.isEmpty {
                    ContentUnavailableView("No Medicines", systemImage: "cross.case", description: Text("Add your first medicine to start tracking its expiry date."))
                } else {
                    List(medicineViewModel.medicines) { medicine in
                        NavigationLink {
                            MedicineDetailView(medicine: medicine, medicineViewModel: medicineViewModel)
                        } label: {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(medicine.name)
                                    .font(.headline)
                                Text(medicine.category)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text("Expires \(medicine.expiryDate.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                if let location = medicine.storageLocation {
                                    Text(location.name)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("My Medicines")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddMedicine = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                medicineViewModel.loadMedicines()
            }
        }
        .sheet(isPresented: $showingAddMedicine) {
            AddMedicineView(medicineViewModel: medicineViewModel)
        }
    }
}

#Preview {
    MedicineListView(
        repository: JSONMedicineRepository()
    )
}
