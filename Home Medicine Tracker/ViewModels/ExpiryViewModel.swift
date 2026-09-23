//
//  ExpiryViewModel.swift
//  Home Medicine Tracker
//
//  Created by Djy on 23/09/2026.
//

import Foundation
import Combine

@MainActor
final class ExpiryViewModel: ObservableObject {
    
    @Published var expiringMedicines: [Medicine] = []
    @Published var expiredMedicines: [Medicine] = []
    @Published var errorMessage: String?
    
    private let getExpiringMedicinesUseCase: GetExpiringMedicinesUseCase
    private let getExpiredMedicinesUseCase: GetExpiredMedicinesUseCase
    
    init(getExpiringMedicinesUseCase: GetExpiringMedicinesUseCase, getExpiredMedicinesUseCase: GetExpiredMedicinesUseCase) {
        self.getExpiringMedicinesUseCase = getExpiringMedicinesUseCase
        self.getExpiredMedicinesUseCase = getExpiredMedicinesUseCase
    }
    
    func loadExpiryMedicines() {
        do {
            expiringMedicines = try getExpiringMedicinesUseCase.execute()
            expiredMedicines = try getExpiredMedicinesUseCase.execute()
            errorMessage = nil
        } catch {
            errorMessage = "Unable to load expiry information."
        }
    }
}
