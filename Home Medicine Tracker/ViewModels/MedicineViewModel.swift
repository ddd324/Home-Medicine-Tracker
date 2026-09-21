//
//  MedicineViewModel.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import Foundation
import Combine

@MainActor
final class MedicineViewModel: ObservableObject {
    
    @Published var medicines: [Medicine] = []
    
    private let getMedicinesUseCase: GetMedicinesUseCase
    
    init(getMedicinesUseCase: GetMedicinesUseCase) {
        self.getMedicinesUseCase = getMedicinesUseCase
    }
    
    func loadMedicines() {
        do {
            medicines = try getMedicinesUseCase.execute()
        } catch {
            print("Failed to load medicines: \(error)")
        }
    }
}
