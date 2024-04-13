//
//  FlightSearchAction.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// FlightSearchAction.swift
import Foundation

enum FlightSearchAction: Equatable {
    case onAppear
    case searchFlights
    case searchFlightsResponse(Result<FlightResponse?, FlightSearchError>)
    case sortByPrice
    case sortByTotalDuration
    case showMoreFlights
    case selectFlightOffer(FlightOffer?)
    case flightDetail(FlightOffer)
}
