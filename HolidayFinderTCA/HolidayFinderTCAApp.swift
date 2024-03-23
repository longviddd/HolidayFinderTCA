//
//  HolidayFinderTCAApp.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import SwiftUI
import ComposableArchitecture

@main
struct HolidayFinderApp: App {
    var body: some Scene {
        WindowGroup {
            let holidaySearchStore = Store(
                initialState: HolidaySearchState(),
                reducer: holidaySearchReducer,
                environment: HolidaySearchEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    fetchVacationLocations: {
                        Effect.task {
                            do {
                                let locations = try await NetworkService.shared.fetchAvailableCountries()
                                return locations
                            } catch {
                                throw error
                            }
                        }
                    }
                )
            )
            
            NavigationView {
                HolidaySearchView(store: holidaySearchStore)
            }
        }
    }
}
