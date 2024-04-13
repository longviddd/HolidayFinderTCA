//
//  AirportSelectionState.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// AirportSelectionState.swift
import Foundation
import ComposableArchitecture

struct AirportSelectionState: Equatable {
    var airports: IdentifiedArrayOf<Airport> = []
    var filteredAirports: IdentifiedArrayOf<Airport> = []
    var selectedAirport: Airport?
    var isLoading = false
    var searchQuery = ""
    var showMainView = false
}
