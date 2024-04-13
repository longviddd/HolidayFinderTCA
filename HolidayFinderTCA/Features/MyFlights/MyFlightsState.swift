//
//  MyFlightsState.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// MyFlightsState.swift
import Foundation
import ComposableArchitecture

struct MyFlightsState: Equatable {
    var savedFlights: IdentifiedArrayOf<FlightResponsePrice> = []
    var isLoading = false
}
