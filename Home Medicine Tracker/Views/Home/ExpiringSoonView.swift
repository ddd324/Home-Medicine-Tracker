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
            Section {
                Picker("Exxpiry Range", selection: $expiryViewModel.selectedDays) {
                    Text("7 Days").tag(7)
                    Text("30 Days").tag(30)
                    Text("60 Days").tag(60)
                }
                .pickerStyle(.segmented)
                .onChange(of: expiryViewModel.selectedDays) { _, newValue in
                    expiryViewModel.changeExpiryRange(to: newValue)
                }
            }
            Section("Next \(expiryViewModel.selectedDays) Days") {
                if expiryViewModel.expiringMedicines.isEmpty {
                    Text("No medicines expiring in the next \(expiryViewModel.selectedDays) days.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(expiryViewModel.expiringMedicines) { medicine in
                        medicineRow(medicine)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("Background"))
        .navigationTitle("Expiring Soon")
        .task {
            expiryViewModel.loadExpiryMedicines()
        }
        .onAppear {
            expiryViewModel.loadExpiryMedicines()
        }
    }
    
    private func medicineRow(_ medicine: Medicine) -> some View {
        let daysRemaining = daysUntilExpiry(for: medicine)
        
        return NavigationLink {
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
                        .foregroundStyle(.orange)
                        .frame(width: 70, height: 70)
                        .background(Color("Peach"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(medicine.name)
                        .font(.headline)
                    Text("Expires \(medicine.expiryDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    if daysRemaining == 0 {
                        Text("Expires today")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.orange)
                    } else {
                        Text("Expires in \(daysRemaining) \(daysRemaining == 1 ? "day" : "days")")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.orange)
                    }
                    
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
    
    private func daysUntilExpiry(for medicine: Medicine) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let expiryDate = calendar.startOfDay(for: medicine.expiryDate)
        
        return calendar.dateComponents([.day], from: today, to: expiryDate).day ?? 0
    }
}

