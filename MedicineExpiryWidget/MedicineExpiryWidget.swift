//
//  MedicineExpiryWidget.swift
//  MedicineExpiryWidget
//
//  Created by Djy on 24/09/2026.
//

import WidgetKit
import SwiftUI

struct MedicineWidgetEntry: TimelineEntry {
    let date: Date
    let medicines: [WidgetMedicine]
}

struct MedicineWidgetProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> MedicineWidgetEntry {
        MedicineWidgetEntry(date: .now, medicines: [WidgetMedicine(id: UUID(), name: "Eye Drops", expiryDate: Date(), storageLocationName: "Medicine Cabinet")])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MedicineWidgetEntry) -> Void) {
        let medicines = WidgetMedicineData.load()
        completion(MedicineWidgetEntry(date: .now, medicines: medicines))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MedicineWidgetEntry>) -> Void) {
        let medicines = WidgetMedicineData.load()
        let entry = MedicineWidgetEntry(date: .now, medicines: medicines)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct MedicineExpiryWidgetView : View {
    var entry: MedicineWidgetEntry
    
    @Environment(\.widgetFamily) private var family

    var body: some View {
        if family == .systemSmall {
            smallWidget
        } else if family == .systemMedium {
            mediumWidget
        } else if family == .systemLarge {
            largeWidget
        } else {
            Text("Something Went Wrong")
        }
    }
    
    private var smallWidget: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Expiring Soon", systemImage: "pills.fill")
                .font(.headline)
            
            if let medicine = entry.medicines.first {
                Spacer()
                Text(medicine.name)
                    .font(.headline)
                    .lineLimit(2)
                Text(medicine.expiryDate, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if let location = medicine.storageLocationName {
                    Text(location)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            } else {
                Spacer()
                Text("No medicines expiring soon")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    private var mediumWidget: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Expiring Soon", systemImage: "pills.fill")
                .font(.headline)
            
            if entry.medicines.isEmpty {
                Spacer()
                Text("No medicines expiring soon")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                ForEach(entry.medicines.prefix(3)) { medicine in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(medicine.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .lineLimit(1)
                            
                            if let location = medicine.storageLocationName {
                                Text(location)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        Spacer()
                        Text(medicine.expiryDate, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    private var largeWidget: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Expiring Soon", systemImage: "pills.fill")
                .font(.title2)
                .fontWeight(.semibold)

            if entry.medicines.isEmpty {
                Spacer()
                Text("No medicines expiring soon")
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                ForEach(entry.medicines.prefix(3)) { medicine in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(medicine.name)
                                .font(.headline)
                            Spacer()
                            Text(medicine.expiryDate, style: .date)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        if let location = medicine.storageLocationName {
                            Label(location, systemImage: "cabinet.fill")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    if medicine.id != entry.medicines.prefix(3).last?.id {
                        Divider()
                    }
                }

                Spacer()

                Text("Check medicines regularly and return expired or unwanted medicines to a community pharmacy.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}


struct MedicineExpiryWidget: Widget {
    let kind: String = "MedicineExpiryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MedicineWidgetProvider()) { entry in
            MedicineExpiryWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Medicine Expiry")
        .description("See household medicines that are expiring soon.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview("Medicine Expiry - Small", as: .systemSmall) {
    MedicineExpiryWidget()
} timeline: {
    MedicineWidgetEntry(date: .now, medicines: [WidgetMedicine(id: UUID(), name: "Eye Drops", expiryDate: .now, storageLocationName: "Medicine Cabinet")])
}

#Preview("Medicine Expiry - Medium", as: .systemMedium) {
    MedicineExpiryWidget()
} timeline: {
    MedicineWidgetEntry(date: .now, medicines: [WidgetMedicine(id: UUID(), name: "Eye Drops", expiryDate: .now, storageLocationName: "Medicine Cabinet"), WidgetMedicine(id: UUID(), name: "Antihistamine", expiryDate: .now, storageLocationName: "Kitchen Cabinet")])
}

#Preview("Medicine Expiry - Large", as: .systemLarge) {
    MedicineExpiryWidget()
} timeline: {
    MedicineWidgetEntry(date: .now, medicines: [WidgetMedicine(id: UUID(), name: "Eye Drops", expiryDate: .now, storageLocationName: "Medicine Cabinet"), WidgetMedicine(id: UUID(), name: "Antihistamine", expiryDate: .now, storageLocationName: "Kitchen Cabinet"), WidgetMedicine(id: UUID(), name: "Hydrocortisone Cream", expiryDate: .now, storageLocationName: "Kitchen Cabinet")])
}
