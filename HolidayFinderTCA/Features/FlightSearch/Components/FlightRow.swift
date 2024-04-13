//
//  FlightRow.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct FlightRow: View {
    let flight: Flight
    @Binding var selectedFlightOffer: FlightOffer?
    let flightOffers: IdentifiedArrayOf<FlightOffer>
    let store: Store<FlightSearchState, FlightSearchAction>
    var body: some View {
        IfLetStore(
            store.scope(
                state: { $0.selectedFlightOffer },
                action: { .flightDetail($0) }
            ),
            then: { selectedFlightOfferStore in
                WithViewStore(selectedFlightOfferStore) { viewStore in
                    NavigationLink(
                        destination: FlightDetailView(
                            store: Store(
                                initialState: FlightDetailState(selectedFlightOffer: viewStore.state),
                                reducer: flightDetailReducer,
                                environment: FlightDetailEnvironment(
                                    networkService: .live,
                                    mainQueue: .main
                                )
                            )
                        ),
                        tag: selectedFlightOffer!,
                        selection: $selectedFlightOffer
                    ) {
                        FlightRowContent(flight: flight)
                    }
                }
            },
            else: {
                FlightRowContent(flight: flight)
                    .onTapGesture {
                        selectedFlightOffer = findFlightOffer(for: flight, in: flightOffers)
                    }
            }
        )
    }
    
    private func findFlightOffer(for flight: Flight, in flightOffers: IdentifiedArrayOf<FlightOffer>) -> FlightOffer? {
        return flightOffers.first { flightOffer in
            let outboundSegments = flightOffer.itineraries[0].segments
            let returnSegments = flightOffer.itineraries[1].segments
            
            let outboundOriginAirport = outboundSegments[0].departure.iataCode
            let outboundDestinationAirport = outboundSegments[outboundSegments.count - 1].arrival.iataCode
            let returnOriginAirport = returnSegments[0].departure.iataCode
            let returnDestinationAirport = returnSegments[returnSegments.count - 1].arrival.iataCode
            
            return flight.outboundOriginAirport == outboundOriginAirport &&
            flight.outboundDestinationAirport == outboundDestinationAirport &&
            flight.returnOriginAirport == returnOriginAirport &&
            flight.returnDestinationAirport == returnDestinationAirport &&
            flight.price == Double(flightOffer.price.total) ?? 0.0
        }
    }
}
