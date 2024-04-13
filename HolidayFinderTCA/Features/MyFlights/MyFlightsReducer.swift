//
//  MyFlightsReducer.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

import Foundation
import ComposableArchitecture

let myFlightsReducer = Reducer<MyFlightsState, MyFlightsAction, MyFlightsEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        state.isLoading = true
        return Effect(value: .loadSavedFlightsResponse(.success(loadSavedFlightsFromUserDefaults())))
    case let .loadSavedFlightsResponse(.success(savedFlights)):
        state.savedFlights = IdentifiedArray(uniqueElements: savedFlights)
        state.isLoading = false
        return .none
        
    case .loadSavedFlightsResponse(.failure):
        state.isLoading = false
        return .none
        
    case let .deleteFlight(id):
        state.savedFlights.remove(id: id)
        saveFlightsToUserDefaults(state.savedFlights.elements)
        return .none
        
    case .flightDetail:
        return .none
    }
}

private func loadSavedFlightsFromUserDefaults() -> [FlightResponsePrice] {
    if let savedFlightsData = UserDefaults.standard.data(forKey: "myFlights"),
       let savedFlights = try? JSONDecoder().decode([FlightResponsePrice].self, from: savedFlightsData) {
        return savedFlights
    }
    return []
}

private func saveFlightsToUserDefaults(_ flights: [FlightResponsePrice]) {
    if let encodedData = try? JSONEncoder().encode(flights) {
        UserDefaults.standard.set(encodedData, forKey: "myFlights")
    }
}
