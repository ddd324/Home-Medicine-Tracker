# Home Medicine Tracker

## Project Overview

Home Medicine Tracker is an iOS application designed to help adults manage medicines stored at home. The app focuses on three common household medicine management tasks: tracking expiry dates, recording storage locations, and managing the return of expired or unwanted medicines.

Users can add and edit medicines, organise them by storage location, identify medicines that are expiring soon or have already expired, enable expiry reminders, and record medicines as returned.

## Domain Context

Medicines kept at home may be used regularly, occasionally, or only when required. Medicines that are not checked frequently can be forgotten, expire without being noticed, or become difficult to locate when they are needed.

Home Medicine Tracker supports adults who manage household medicines by providing a structured record of:

- medicines currently stored at home
- medicine expiry dates
- storage locations
- expiry reminder preferences
- returned medicines

The app also provides information about the Australian National Return and Disposal of Unwanted Medicines (NatRUM) Program to support the appropriate return of expired or unwanted medicines.

## Architecture

The application uses MVVM with a Use Case layer and Repository pattern.

The main application flow is:

`SwiftUI Views → ViewModels → Use Cases → Repository Protocols → Core Data`

### Semantic Domain Models

The main domain models are:

- `Medicine`
- `StorageLocation`

These models represent domain concepts independently from the Core Data entities used for persistence.

### ViewModels

ViewModels manage presentation state and connect SwiftUI views to the application's Use Cases. They do not access Core Data directly.

Examples include:

- `MedicineViewModel`
- `StorageLocationViewModel`
- `StorageLocationDetailViewModel`
- `ExpiryViewModel`

### Use Cases

Business operations are encapsulated in dedicated Use Case structs, including:

- `AddMedicineUseCase`
- `UpdateMedicineUseCase`
- `MarkMedicineAsReturnedUseCase`
- `GetMedicinesUseCase`
- `GetExpiringMedicinesUseCase`
- `GetExpiredMedicinesUseCase`
- `GetMedicinesByStorageLocationUseCase`
- `AddStorageLocationUseCase`
- `GetStorageLocationsUseCase`
- `UpdateStorageLocationUseCase`

Core business operations enforce domain rules. For example, medicine and storage location names cannot be empty, and a medicine that has already been returned cannot be returned again.

### Repository Layer

Database access is abstracted behind repository protocols:

- `MedicineRepository`
- `StorageLocationRepository`

Core Data repository implementations provide production persistence, while mock repository implementations are used by unit tests. This keeps the Use Case and ViewModel layers independent from the persistence technology.

## Database Choice

Home Medicine Tracker uses Core Data for its primary persistent storage.

Core Data was selected because household medicine information is primarily private, structured data that should remain available between app launches without requiring an internet connection or user account.

The Core Data model contains two related entities:

- `MedicineEntity`
- `StorageLocationEntity`

A medicine can be associated with a storage location, while a storage location can contain multiple medicines.

The repository layer performs domain-specific predicate queries, including fetching active medicines that expire on or before a specified date and fetching active medicines associated with a particular storage location.

## System Extensions

### WidgetKit Widget

The WidgetKit extension allows users to see medicines that are approaching expiry without opening the main application.

The widget reads a shared medicine snapshot from an App Group container. The main application updates this shared data and reloads WidgetKit timelines when relevant medicine data changes.

The widget supports Small, Medium, and Large widget families.

### Notification Content Extension

The Notification Content Extension provides a custom appearance for medicine expiry notifications.

Expiry notifications use the `MEDICINE_EXPIRY` notification category and display domain-relevant information including the medicine name, expiry date, and storage location. This allows the user to understand which household medicine requires attention directly from the notification.

## App Group

The main application and WidgetKit extension share data using the following App Group identifier:

`group.com.jiayi.Home-Medicine-Tracker`

The shared container stores a lightweight widget snapshot derived from the application's primary Core Data records.

## Testing

Unit tests use mock repository implementations rather than the real Core Data stack.

The test suite covers Use Case behaviour including:

- successful business operations
- empty or whitespace-only medicine names
- empty or whitespace-only storage location names
- preventing a medicine from being returned more than once
- expiry-date boundary conditions
- excluding returned medicines from active expiry results
- storage-location medicine queries

## Setup Instructions

1. Clone or download the project repository.
2. Open the Xcode project in Xcode.
3. Select the `Home Medicine Tracker` scheme.
4. Ensure the App Group capability is configured for both the main application and WidgetKit extension using:
   `group.com.jiayi.Home-Medicine-Tracker`
5. Select an iOS Simulator or compatible iOS device.
6. Build and run the `Home Medicine Tracker` application.
7. Add a storage location and medicine to create persistent application data.
8. Add the Home Medicine Tracker widget from the system widget gallery to test WidgetKit integration.
9. Enable an expiry reminder when adding or editing a medicine and allow notification permission when prompted to test the notification workflow.
10. Run the unit test suite in Xcode to verify the Use Case behaviour.

## Technologies

- Swift
- SwiftUI
- Core Data
- WidgetKit
- UserNotifications
- Notification Content Extension
- App Groups
- Swift Testing
