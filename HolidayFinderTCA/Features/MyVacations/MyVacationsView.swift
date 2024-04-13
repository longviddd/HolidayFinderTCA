//
//  MyVacationsView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//


import Foundation
import SwiftUI
import ComposableArchitecture

struct MyVacationsView: View {
    let store: Store<MyVacationsState, MyVacationsAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in

                List {
                    ForEach(viewStore.vacations) { vacation in
                        NavigationLink(
                            destination: FlightSearchView(
                                store: Store(
                                    initialState: FlightSearchState(vacation: vacation),
                                    reducer: flightSearchReducer,
                                    environment: FlightSearchEnvironment(
                                        networkService: .live,
                                        mainQueue: .main
                                    )
                                )
                            )
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "airplane")
                                    Text("\(vacation.originAirport) to \(vacation.destinationAirport)")
                                }
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("\(formatDate(vacation.startDate)) - \(formatDate(vacation.endDate))")
                                }
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewStore.send(.deleteVacation(id: vacation.id))
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
                .navigationTitle("My Vacations")
                .onAppear {
                    viewStore.send(.onAppear)
                }

        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

