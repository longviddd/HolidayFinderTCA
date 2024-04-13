//
//  MyFlightsAction.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// MyFlightsAction.swift
import Foundation
import ComposableArchitecture

enum MyFlightsAction: Equatable {
    case onAppear
    case loadSavedFlightsResponse(Result<[FlightResponsePrice], Never>)
    case deleteFlight(id: FlightResponsePrice.ID)
    case flightDetail(FlightOffer)
}
