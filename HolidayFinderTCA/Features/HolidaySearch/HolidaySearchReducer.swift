//
//  HolidaySearchReducer.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
import ComposableArchitecture

let holidaySearchReducer = Reducer<HolidaySearchState, HolidaySearchAction, HolidaySearchEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        return environment.fetchVacationLocations()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(HolidaySearchAction.fetchVacationLocationsResponse)
    case let .validateYearInput(year):
        guard let yearValue = Int(year), yearValue >= Calendar.current.component(.year, from: Date()), yearValue <= 2073 else {
            state.isYearValid = false
            return .none
        }
        state.yearSearch = year
        state.isYearValid = true
        return .none
    case .submitSearch:
        guard state.isYearValid else { return .none }
        let searchParameters = ["selectedCountry": state.vacationLocation, "selectedYear": state.yearSearch, "upcomingCurrentYearOnly": state.upcomingCurrentYearOnly]
        UserDefaults.standard.set(searchParameters, forKey: "searchParameters")
        print("Submitting search for location: \(state.vacationLocation)")
        state.shouldNavigate = true
        return .none
    case let .fetchVacationLocationsResponse(.success(locations)):
        state.vacationLocationsJson = locations
        if let firstCountryCode = locations.first?.countryCode {
            state.vacationLocation = firstCountryCode
        }
        return .none
    case let .fetchVacationLocationsResponse(.failure(error)):
        print("Error fetching vacation locations: \(error)")
        return .none
    case let .handleUpcomingCurrentYearOnlyChange(newValue):
        state.upcomingCurrentYearOnly = newValue
        if newValue {
            let currentYearStr = String(Calendar.current.component(.year, from: Date()))
            state.yearSearch = currentYearStr
        }
        return .none
    case let .setNeedsAirportSelection(needsSelection):
        state.needsAirportSelection = needsSelection
        return .none
    }
}
