//
//  NatRUMInformationView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import SwiftUI

struct NatRUMInformationView: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        List {
            Section("Safe Medicine Disposal") {
                Text(
                    "Expired and unwanted medicines should be returned to a participating community pharmacy for safe disposal."
                )
            }

            Section("NatRUM Program") {
                Text(
                    "The National Return and Disposal of Unwanted Medicines (NatRUM) Program allows people in Australia to return expired and unwanted medicines to participating community pharmacies at no cost."
                )
            }

            Section("How to Return Medicines") {
                Text(
                    "Take your expired or unwanted medicines to a participating community pharmacy for safe collection and disposal."
                )
            }

            Section {
                Button("Visit Official NatRUM Website") {
                    if let url = URL(
                        string: "https://www.health.gov.au/our-work/national-return-and-disposal-of-unwanted-medicines-program-natrum"
                    ) {
                        openURL(url)
                    }
                }
            }
        }
        .navigationTitle("NatRUM Information")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NatRUMInformationView()
}
