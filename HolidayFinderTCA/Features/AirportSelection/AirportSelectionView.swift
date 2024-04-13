//
//  AirportSelectionView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//


// AirportSelectionView.swift
import SwiftUI
import ComposableArchitecture

struct AirportSelectionView: View {
    let store: Store<AirportSelectionState, AirportSelectionAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.filteredAirports) { airport in
                    Button(action: {
                        viewStore.send(.setSelectedAirport(airport))
                        viewStore.send(.saveSelectedAirport)
                        viewStore.send(.showMainView)
                    }) {
                        Text("\(airport.city ?? ""), \(airport.country ?? "") - \(airport.name ?? "")")
                            .foregroundColor(.primary)
                    }
                }
            }
            .searchable(
                text: viewStore.binding(
                    get: \.searchQuery,
                    send: AirportSelectionAction.searchAirports
                ),
                prompt: "Search Airports"
            )
            .navigationBarTitle("Choose Your Preferred Airport")
            .overlay(
                Group {
                    if viewStore.isLoading {
                        ProgressView()
                    }
                }
            )
            .fullScreenCover(isPresented: viewStore.binding(
                get: \.showMainView,
                send: { _ in .showMainView }
            )) {
                RootView(
                    store: Store(
                        initialState: RootState(),
                        reducer: rootReducer,
                        environment: RootEnvironment(
                            holidaySearchEnvironment: HolidaySearchEnvironment(
                                networkService: .live,
                                mainQueue: .main
                            ),
                            myVacationsEnvironment: MyVacationsEnvironment(
                                mainQueue: .main
                            ),
                            myFlightsEnvironment: MyFlightsEnvironment(
                                mainQueue: .main
                            )
                        )
                    )
                )
            }
            .onAppear {
                ViewStore(store).send(.onAppear)
            }
        }
    }
}
