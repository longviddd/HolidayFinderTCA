//
//  FlightSearchView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// FlightSearchView.swift
import SwiftUI
import ComposableArchitecture

struct FlightSearchView: View {
    let store: Store<FlightSearchState, FlightSearchAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HeaderView(vacation: viewStore.vacation)
                    
                    if viewStore.isLoading {
                        LoadingView()
                    } else if viewStore.fetchError {
                        ErrorView {
                            viewStore.send(.searchFlights)
                        }
                    } else if viewStore.noFlightsFound {
                        NoFlightsFoundView {
                            viewStore.send(.searchFlights)
                        }
                    } else {
                        SortButtonsView(
                            sortByDuration: {
                                viewStore.send(.sortByTotalDuration)
                            },
                            sortByPrice: {
                                viewStore.send(.sortByPrice)
                            }
                        )
                        
                        ForEach(viewStore.flights.prefix(viewStore.visibleFlights)) { flight in
                            FlightRow(
                                flight: flight,
                                selectedFlightOffer: viewStore.binding(
                                    get: \.selectedFlightOffer,
                                    send: FlightSearchAction.selectFlightOffer
                                ),
                                flightOffers: viewStore.flightOffers,
                                store: store
                            )
                        }
                        
                        if viewStore.visibleFlights < viewStore.flights.count {
                            ShowMoreButton {
                                viewStore.send(.showMoreFlights)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .navigationBarTitle("Flight Search", displayMode: .inline)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

