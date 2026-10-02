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
                        HStack(spacing: 12) {
                            if let photoData = medicine.photoData,
                               let uiImage = UIImage(data: photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .clipped()
                            } else {
                                Image(systemName: "pills.fill")
                                    .foregroundStyle(.red)
                                    .frame(width: 70, height: 70)
                                    .background(Color("Coral"))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(medicine.name)
                                    .font(.headline)
                                Text("Expired \(medicine.expiryDate.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.subheadline)
                                    .foregroundStyle(.red)
                                
                                if let location = medicine.storageLocation {
                                    Text(location.name)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(Color.white)
                        }
                        
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("Background"))
        .navigationTitle("Expired Medicines")
        .task {
            expiryViewModel.loadExpiryMedicines()
        }
        .onAppear {
            expiryViewModel.loadExpiryMedicines()
        }
    }
}
