//
//  HolidayFinderTCAApp.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import SwiftUI

@main
struct HolidayFinderTCAApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
