//
//  FlightDetailView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// FlightDetailView.swift
import SwiftUI
import ComposableArchitecture

struct FlightDetailView: View {
    let store: Store<FlightDetailState, FlightDetailAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    FlightHeaderView(
                        routeTitle: viewStore.routeTitle,
                        validatingCarrier: viewStore.validatingCarrier,
                        totalPrice: viewStore.totalPrice
                    )
                    
                    if viewStore.isLoading {
                        LoadingView()
                    } else if let flightDetails = viewStore.flightDetails {
                        ForEach(Array(flightDetails.data.flightOffers[0].itineraries.enumerated()), id: \.offset) { index, itinerary in
                            ForEach(Array(itinerary.segments.enumerated()), id: \.offset) { segmentIndex, segment in
                                FlightSegmentView(
                                    segment: segment,
                                    isReturn: index % 2 != 0
                                )
                            }
                        }
                    }
                    
                    if !viewStore.isFromMyFlights {
                        SaveFlightButton(
                            action: {
                                viewStore.send(.saveFlightToMyList)
                            }
                        )
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitle("Flight Details", displayMode: .inline)
            .alert(
                isPresented: viewStore.binding(
                    get: \.showingAlert,
                    send: .alertDismissed
                )
            ) {
                Alert(
                    title: Text(viewStore.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if viewStore.alertMessage == "Flight saved successfully" {
                        }
                    }
                )
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
