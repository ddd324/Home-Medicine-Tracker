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
            Section {
                HStack(spacing: 14) {
                    Image(systemName: "leaf.fill")
                        .font(.title2)
                        .foregroundStyle(.green)
                        .frame(width: 48, height: 48)
                        .background(Color("Mint"))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Return expired and unwanted medicines safely")
                            .font(.headline)
                        Text("Help protect your community and the environment.")
                            .font(.subheadline)
                            .foregroundStyle(.green)
                    }
                }
                .padding(.vertical, 8)
            }
            .listRowBackground(Color("Mint"))

            Section {
                Label {
                    Text("What is NatRUM?")
                        .font(.headline)
                    Text("The National Return and Disposal of Unwanted Medicines (NatRUM) Program allows people in Australia to return expired and unwanted medicines to participating community pharmacies at no cost.")
                } icon: {
                    Image(systemName: "doc.text.fill")
                        .foregroundStyle(Color("Primary"))
                }
            }
            .listRowBackground(Color("SkyBlue"))

            Section {
                Label {
                    Text("How to Return Medicines")
                        .font(.headline)
                    Text("Take your expired or unwanted medicines to a participating community pharmacy for safe collection and disposal.")
                } icon: {
                    Image(systemName: "bag.fill")
                        .foregroundStyle(.orange)
                }
            }
            .listRowBackground(Color("Peach"))
            
            Section {
                Button {
                    if let url = URL(
                        string: "https://www.health.gov.au/our-work/national-return-and-disposal-of-unwanted-medicines-program-natrum"
                    ) {
                        openURL(url)
                    }
                } label: {
                    Label(
                        "Visit Official NatRUM Website",
                        systemImage: "safari.fill"
                    )
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("Primary"))
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("Background"))
        .navigationTitle("NatRUM Information")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NatRUMInformationView()
}
