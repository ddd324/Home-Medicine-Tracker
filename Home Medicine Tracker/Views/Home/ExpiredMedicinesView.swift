//
//  ExpiredMedicinesView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 24/09/2026.
//

import SwiftUI

struct ExpiredMedicinesView: View {
    
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
            if expiryViewModel.expiredMedicines.isEmpty {
                Text("No expired medicines.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(expiryViewModel.expiredMedicines) { medicine in
                    NavigationLink {
                        MedicineDetailView(medicine: medicine, medicineViewModel: medicineViewModel)
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(medicine.name)
                                .font(.headline)
                            Text("Expired \(medicine.expiryDate.formatted(date: .abbreviated, time: .omitted))")
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
        }
        .navigationTitle("Expired Medicines")
        .task {
            expiryViewModel.loadExpiryMedicines()
        }
        .onAppear {
            expiryViewModel.loadExpiryMedicines()
        }
    }
}
