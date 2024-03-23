//
//  HolidaySearchView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct HolidaySearchView: View {
    let store: Store<HolidaySearchState, HolidaySearchAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text("Holiday Vacation Search")
                    .font(.title)
                Text("Find the best holidays tailored for you")
                    .font(.subheadline)
             
                Picker("Select Vacation Location", selection: viewStore.binding(
                    get: \.vacationLocation,
                    send: HolidaySearchAction.validateYearInput
                )) {
                    if viewStore.vacationLocation.isEmpty {
                        Text("").tag(Optional<String>(nil))
                    }
                    ForEach(viewStore.vacationLocationsJson, id: \.countryCode) { country in
                        Text(country.name).tag(country.countryCode)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Toggle(isOn: viewStore.binding(
                    get: \.upcomingCurrentYearOnly,
                    send: HolidaySearchAction.handleUpcomingCurrentYearOnlyChange
                )) {
                    Text("Upcoming in Current Year Only")
                }
                .padding()

                TextField("Enter Year (current year to 2073)", text: viewStore.binding(
                    get: \.yearSearch,
                    send: HolidaySearchAction.validateYearInput
                ))
                .keyboardType(.numberPad)
                .padding()
                .disabled(viewStore.upcomingCurrentYearOnly)

                Button("Submit") {
                    viewStore.send(.submitSearch)
                }
                .disabled(!viewStore.isYearValid)
                .padding()

//                NavigationLink(
//                    destination: HolidayListView(store: store),
//                    isActive: viewStore.binding(
//                        get: \.shouldNavigate,
//                        send: .setNeedsAirportSelection(false)
//                    )
//                ) {
//                    EmptyView()
//                }
            }
            .padding()
            .onAppear {
                viewStore.send(.onAppear)
                viewStore.send(.setNeedsAirportSelection(viewStore.needsAirportSelection))
            }
//            .sheet(isPresented: viewStore.binding(
//                get: \.needsAirportSelection,
//                send: .setNeedsAirportSelection
//            )) {
//                AirportSelectionView(store: store)
//            }
        }
    }
}
