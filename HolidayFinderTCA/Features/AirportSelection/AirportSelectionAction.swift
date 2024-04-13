//
//  AirportSelectionAction.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// AirportSelectionAction.swift
import Foundation

enum AirportSelectionAction: Equatable {
    case onAppear
    case fetchAirportsResponse(Result<[Airport], Never>)
    case searchAirports(query: String)
    case setSelectedAirport(Airport?)
    case saveSelectedAirport
    case showMainView
}
