//
//  FlightSearchReducer.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// FlightSearchReducer.swift
import ComposableArchitecture
import Foundation

let flightSearchReducer = Reducer<FlightSearchState, FlightSearchAction, FlightSearchEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        return .init(value: .searchFlights)
    case .searchFlights:
        state.isLoading = true
        state.fetchError = false
        state.noFlightsFound = false
        let originAirport = state.vacation.originAirport
        let destinationAirport = state.vacation.destinationAirport
        let startDate = dateString(from: state.vacation.startDate)
        let endDate = dateString(from: state.vacation.endDate)
        
        return environment.networkService.fetchAuthToken()
            .flatMap { token in
                environment.networkService.fetchFlights(
                    originAirport,
                    destinationAirport,
                    startDate,
                    endDate,
                    1,
                    token
                )
            }
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map { result in
                switch result {
                case .success(let flightResponse):
                    return .searchFlightsResponse(.success(flightResponse))
                case .failure(let error):
                    return .searchFlightsResponse(.failure(FlightSearchError.fetchFailed))
                }
            }
        
    case let .searchFlightsResponse(.success(flightResponse)):
        state.isLoading = false
        
        if let flightResponse = flightResponse {
            state.flightOffers = IdentifiedArrayOf(uniqueElements: flightResponse.data)
            if flightResponse.dictionaries == nil {
                state.flights = []
                state.noFlightsFound = true
            } else {
                state.flights = IdentifiedArrayOf(uniqueElements: flightResponse.data.map { flightOffer in
                    let outboundSegments = flightOffer.itineraries[0].segments
                    let returnSegments = flightOffer.itineraries[1].segments
                    let outboundOriginAirport = outboundSegments[0].departure
                    let outboundDestinationAirport = outboundSegments[outboundSegments.count - 1].arrival
                    let outboundDuration = flightOffer.itineraries[0].duration
                    
                    let returnOriginAirport = returnSegments[0].departure
                    let returnDestinationAirport = returnSegments[returnSegments.count - 1].arrival
                    let returnDuration = flightOffer.itineraries[1].duration
                    
                    return Flight(
                        outboundOriginAirport: outboundOriginAirport.iataCode,
                        outboundDestinationAirport: outboundDestinationAirport.iataCode,
                        outboundDuration: formatDuration(outboundDuration!),
                        returnOriginAirport: returnOriginAirport.iataCode,
                        returnDestinationAirport: returnDestinationAirport.iataCode,
                        returnDuration: formatDuration(returnDuration!),
                        price: Double(flightOffer.price.total) ?? 0.0
                    )
                })
            }
        } else {
            state.flights = []
            state.noFlightsFound = true
        }
        return .none
        
    case .searchFlightsResponse(.failure):
        state.isLoading = false
        state.fetchError = true
        return .none
        
    case .sortByPrice:
        state.flights.sort { $0.price < $1.price }
        return .none
        
    case .sortByTotalDuration:
        state.flights.sort { flight1, flight2 in
            let duration1 = durationToMinutes(flight1.outboundDuration) + durationToMinutes(flight1.returnDuration)
            let duration2 = durationToMinutes(flight2.outboundDuration) + durationToMinutes(flight2.returnDuration)
            return duration1 < duration2
        }
        return .none
        
    case .showMoreFlights:
        state.visibleFlights += 5
        return .none
        
    case let .selectFlightOffer(flightOffer):
        state.selectedFlightOffer = flightOffer
        return .none
        
    case .flightDetail:
        return .none
    }
}
private func dateString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
}

private func formatDuration(_ duration: String) -> String {
    return duration.replacingOccurrences(of: "PT", with: "")
}

private func durationToMinutes(_ duration: String) -> Int {
    let components = duration.components(separatedBy: CharacterSet.decimalDigits.inverted)
    let hours = Int(components.first ?? "") ?? 0
    let minutes = Int(components.last ?? "") ?? 0
    return hours * 60 + minutes
}

