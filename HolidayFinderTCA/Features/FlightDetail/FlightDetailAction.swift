//
//  FlightDetailAction.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//
// FlightDetailAction.swift
import Foundation

enum FlightDetailAction: Equatable {
    case onAppear
    case fetchFlightDetailsResponse(Result<FlightResponsePrice?, FlightDetailError>)
    case saveFlightToMyList
    case alertDismissed
    case navigateToMyFlights
}
enum FlightDetailError: Error, Equatable {
    case fetchFailed
}
