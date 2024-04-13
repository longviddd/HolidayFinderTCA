//
//  FlightDetailState.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// FlightDetailState.swift
import Foundation

struct FlightDetailState: Equatable {
    var flightDetails: FlightResponsePrice? = nil
    var isLoading = false
    var routeTitle = ""
    var totalPrice = ""
    var validatingCarrier = ""
    var showingAlert = false
    var alertMessage = ""
    let selectedFlightOffer: FlightOffer
    var isFromMyFlights = false
}
