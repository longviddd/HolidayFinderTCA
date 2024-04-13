//
//  FlightDetailReducer.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// FlightDetailReducer.swift
import ComposableArchitecture
import Foundation

let flightDetailReducer = Reducer<FlightDetailState, FlightDetailAction, FlightDetailEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        state.isLoading = true
        let selectedFlightOffer = state.selectedFlightOffer
        return environment.networkService.fetchAuthToken()
            .flatMap { token in
                environment.networkService.fetchFlightDetails(selectedFlightOffer, token)
            }
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map { result in
                switch result {
                case .success(let flightDetails):
                    return .fetchFlightDetailsResponse(.success(flightDetails))
                case .failure:
                    return .fetchFlightDetailsResponse(.failure(FlightDetailError.fetchFailed))
                }
            }
            .eraseToEffect()
    case let .fetchFlightDetailsResponse(.success(flightDetails)):
        print("run")
        print(flightDetails)
        state.isLoading = false
        state.flightDetails = flightDetails
        state.routeTitle = extractRouteTitle(flightDetails)
        state.totalPrice = extractTotalPrice(flightDetails)
        state.validatingCarrier = extractValidatingCarrier(flightDetails)
        return .none
    case let .fetchFlightDetailsResponse(.failure(error)):
        print("Error fetching flight details: \(error)")
        state.isLoading = false
        return .none
        
    case .saveFlightToMyList:
        guard let flightDetails = state.flightDetails else { return .none }
        
        let encoder = JSONEncoder()
        if let encodedFlightDetails = try? encoder.encode(flightDetails) {
            if var savedFlightsData = UserDefaults.standard.data(forKey: "myFlights") {
                var savedFlights = try? JSONDecoder().decode([FlightResponsePrice].self, from: savedFlightsData)
                savedFlights?.append(flightDetails)
                if let updatedFlightsData = try? encoder.encode(savedFlights) {
                    UserDefaults.standard.set(updatedFlightsData, forKey: "myFlights")
                    state.alertMessage = "Flight saved successfully"
                } else {
                    state.alertMessage = "Failed to save flight. Please try again later."
                }
            } else {
                let firstFlightList = [flightDetails]
                if let firstFlightData = try? encoder.encode(firstFlightList) {
                    UserDefaults.standard.set(firstFlightData, forKey: "myFlights")
                    state.alertMessage = "Flight saved successfully"
                } else {
                    state.alertMessage = "Failed to save flight. Please try again later."
                }
            }
        } else {
            state.alertMessage = "Failed to save flight. Please try again later."
        }
        
        state.showingAlert = true
        
        return .none
        
    case .alertDismissed:
        state.showingAlert = false
        if state.alertMessage == "Flight saved successfully" {
            return Effect(value: .navigateToMyFlights)
        }
        return .none
        
    case .navigateToMyFlights:
        return .none
    }
}
private func extractRouteTitle(_ flightDetails: FlightResponsePrice?) -> String {
    guard let flightDetails = flightDetails,
          !flightDetails.data.flightOffers.isEmpty,
          !flightDetails.data.flightOffers[0].itineraries.isEmpty else {
        return ""
    }
    let firstItinerary = flightDetails.data.flightOffers[0].itineraries[0]
    let lastItinerary = flightDetails.data.flightOffers[0].itineraries.last ?? firstItinerary
    let originLocation = firstItinerary.segments[0].departure.iataCode
    let destination = lastItinerary.segments.last?.arrival.iataCode ?? ""
    return "Flight from \(originLocation) - \(destination)"
}

private func extractTotalPrice(_ flightDetails: FlightResponsePrice?) -> String {
    guard let flightDetails = flightDetails,
          !flightDetails.data.flightOffers.isEmpty else {
        return ""
    }
    return flightDetails.data.flightOffers[0].price.total
}

private func extractValidatingCarrier(_ flightDetails: FlightResponsePrice?) -> String {
    guard let flightDetails = flightDetails,
          !flightDetails.data.flightOffers.isEmpty else {
        return ""
    }
    return flightDetails.data.flightOffers[0].validatingAirlineCodes[0]
}
