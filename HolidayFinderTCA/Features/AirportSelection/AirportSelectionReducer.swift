//
//  AirportSelectionReducer.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// AirportSelectionReducer.swift
import ComposableArchitecture
import Foundation

let airportSelectionReducer = Reducer<AirportSelectionState, AirportSelectionAction, AirportSelectionEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        state.isLoading = true
        return environment.networkService.fetchAirports()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AirportSelectionAction.fetchAirportsResponse)
    case let .fetchAirportsResponse(.success(airports)):
        state.airports = IdentifiedArrayOf(uniqueElements: airports)
        state.filteredAirports = state.airports
        state.isLoading = false
        return .none
    case .fetchAirportsResponse(.failure):
        state.isLoading = false
        return .none
        
    case let .searchAirports(query):
        state.searchQuery = query
        if query.isEmpty {
            state.filteredAirports = state.airports
        } else {
            state.filteredAirports = state.airports.filter { airport in
                (airport.name ?? "").localizedCaseInsensitiveContains(query) ||
                (airport.city ?? "").localizedCaseInsensitiveContains(query) ||
                (airport.country ?? "").localizedCaseInsensitiveContains(query) ||
                (airport.iata ?? "").localizedCaseInsensitiveContains(query)
            }
        }
        return .none
        
    case let .setSelectedAirport(airport):
        state.selectedAirport = airport
        return .none
        
    case .saveSelectedAirport:
        if let selectedAirport = state.selectedAirport,
           let encodedAirport = try? JSONEncoder().encode(selectedAirport) {
            UserDefaults.standard.set(encodedAirport, forKey: "selectedAirport")
        }
        return .none
        
    case .showMainView:
        state.showMainView = true
        return .none
    }
}
