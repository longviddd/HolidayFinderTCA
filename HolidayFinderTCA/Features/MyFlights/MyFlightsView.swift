//
//  MyFlightsView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// MyFlightsView.swift
import SwiftUI
import ComposableArchitecture

struct MyFlightsView: View {
    let store: Store<MyFlightsState, MyFlightsAction>
    @State private var selectedFlight: FlightResponsePrice?
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.gray)
                    Text("Price may have changed since you last saved the flights. Press on a specific flight to check.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                
                if viewStore.isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewStore.savedFlights) { flight in
                            Button(action: {
                                self.selectedFlight = flight
                            }) {
                                MyFlightRow(flight: flight)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewStore.send(.deleteFlight(id: flight.id))
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("My Flights", displayMode: .inline)
            .sheet(item: $selectedFlight) { flight in
                FlightDetailView(
                    store: Store(
                        initialState: FlightDetailState(
                            selectedFlightOffer: flight.data.flightOffers[0],
                            isFromMyFlights: true
                        ),
                        reducer: flightDetailReducer,
                        environment: FlightDetailEnvironment(
                            networkService: .live,
                            mainQueue: .main
                        )
                    )
                )
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct MyFlightRow: View {
    let flight: FlightResponsePrice
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            let firstOutboundSegment = flight.data.flightOffers[0].itineraries[0].segments[0]
            let lastOutboundSegment = flight.data.flightOffers[0].itineraries[0].segments.last!
            let firstReturnSegment = flight.data.flightOffers[0].itineraries[1].segments[0]
            let lastReturnSegment = flight.data.flightOffers[0].itineraries[1].segments.last!
            
            HStack {
                Image(systemName: "airplane.departure")
                Text("\(firstOutboundSegment.departure.iataCode) -> \(lastOutboundSegment.arrival.iataCode)")
            }
            
            HStack {
                Image(systemName: "airplane.arrival")
                Text("\(firstReturnSegment.departure.iataCode) -> \(lastReturnSegment.arrival.iataCode)")
            }
            
            HStack {
                Image(systemName: "calendar")
                Text("Start: \(formatDate(firstOutboundSegment.departure.at))")
            }
            
            HStack {
                Image(systemName: "calendar")
                Text("End: \(formatDate(lastReturnSegment.arrival.at))")
            }
            
            HStack {
                Image(systemName: "tag")
                Text("\(flight.data.flightOffers[0].price.total) \(flight.data.flightOffers[0].price.currency)")
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}

