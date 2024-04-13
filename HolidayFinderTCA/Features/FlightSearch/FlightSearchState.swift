//
//  FlightSearchState.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// FlightSearchState.swift
import Foundation
import ComposableArchitecture

struct FlightSearchState: Equatable {
    var vacation: VacationDetails
    var flights: IdentifiedArrayOf<Flight> = []
    var isLoading = false
    var fetchError = false
    var noFlightsFound = false
    var flightOffers: IdentifiedArrayOf<FlightOffer> = []
    var visibleFlights = 5
    var selectedFlightOffer: FlightOffer?
    
}
enum FlightSearchError: Error, Equatable {
    case fetchFailed
}
