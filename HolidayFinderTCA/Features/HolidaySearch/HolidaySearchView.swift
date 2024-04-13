//
//  HolidaySearchView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
// HolidaySearchView.swift
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
                    send: HolidaySearchAction.updateVacationLocation
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
                    send: HolidaySearchAction.updateUpcomingCurrentYearOnly
                )) {
                    Text("Upcoming in Current Year Only")
                }
                .padding()
                
                YearPickerView(
                    selectedYear: viewStore.binding(
                        get: \.yearSearch,
                        send: HolidaySearchAction.updateYearSearch
                    ),
                    isDisabled: viewStore.upcomingCurrentYearOnly
                )
                .padding()
                
                Button("Submit") {
                    viewStore.send(.submitSearch)
                }
                .disabled(!viewStore.isYearValid)
                .padding()
                
                NavigationLink(
                    destination: HolidayListView(
                        store: Store(
                            initialState: viewStore.holidayList.first ?? HolidayListState(),
                            reducer: holidayListReducer,
                            environment: HolidayListEnvironment()
                        )
                    ),
                    isActive: viewStore.binding(
                        get: \.isNavigatingToHolidayList,
                        send: { _ in HolidaySearchAction.resetNavigationState }
                    )
                ) {
                    EmptyView()
                }
            }
            .padding()
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
