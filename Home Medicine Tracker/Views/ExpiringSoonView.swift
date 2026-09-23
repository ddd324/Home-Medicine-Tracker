//
//  ExpiringSoonView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 23/09/2026.
//

import SwiftUI

struct ExpiringSoonView: View {
    
    @StateObject private var expiryViewModel: ExpiryViewModel
    @StateObject private var medicineViewModel: MedicineViewModel
    
    init(repository: MedicineRepository) {
        let getExpiringMedicinesUseCase = GetExpiringMedicinesUseCase(repository: repository)
        let getExpiredMedicinesUseCase = GetExpiredMedicinesUseCase(repository: repository)
        
        _expiryViewModel = StateObject(wrappedValue: ExpiryViewModel(getExpiringMedicinesUseCase: getExpiringMedicinesUseCase, getExpiredMedicinesUseCase: getExpiredMedicinesUseCase))
        
        let getMedicinesUseCase = GetMedicinesUseCase(repository: repository)
        let addMedicineUseCase = AddMedicineUseCase(repository: repository)
        let updateMedicineUseCase = UpdateMedicineUseCase(repository: repository)
        let markMedicineAsReturnedUseCase = MarkMedicineAsReturnedUseCase(repository: repository)
        
        _medicineViewModel = StateObject(wrappedValue: MedicineViewModel(getMedicinesUseCase: getMedicinesUseCase, addMedicineUseCase: addMedicineUseCase, updateMedicineUseCase: updateMedicineUseCase, markMedicineAsReturnedUseCase: markMedicineAsReturnedUseCase))
    }
    
    var body: some View {
        List {
            Section("Next 30 Days") {
                if expiryViewModel.expiringMedicines.isEmpty {
                    Text("No medicines expiring in the next 30 days.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(expiryViewModel.expiringMedicines) { medicine in
                        medicineRow(medicine)
                    }
                }
            }
            
            Section("Expired") {
                if expiryViewModel.expiredMedicines.isEmpty {
                    Text("No expired medicines.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(expiryViewModel.expiredMedicines) { medicine in
                        medicineRow(medicine)
                    }
                }
            }
        }
        .navigationTitle("Expiring Soon")
        .task {
            expiryViewModel.loadExpiryMedicines()
        }
        .onAppear {
            expiryViewModel.loadExpiryMedicines()
        }
    }
    
    private func medicineRow(_ medicine: Medicine) -> some View {
        NavigationLink {
            MedicineDetailView(medicine: medicine, medicineViewModel: medicineViewModel)
        } label: {
            VStack(alignment: .leading, spacing: 5) {
                Text(medicine.name)
                    .font(.headline)
                Text("Expires \(medicine.expiryDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if let location = medicine.storageLocation {
                    Text(location.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

