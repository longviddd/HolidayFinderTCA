//
//  HolidaySearchReducer.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
import ComposableArchitecture

let holidaySearchReducer = Reducer<HolidaySearchState, HolidaySearchAction, HolidaySearchEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        return .init(value: .searchVacationLocations)
    case .searchVacationLocations:
        return environment.networkService.fetchAvailableCountries()
            .receive(on: environment.mainQueue)
            .catchToEffect() { result in
                switch result {
                case let .success(countries):
                    return .searchVacationLocationsResponse(.success(countries))
                case .failure:
                    return .searchVacationLocationsResponse(.failure(HolidaySearchError.fetchFailed))
                }
            }
    case let .searchVacationLocationsResponse(.success(countries)):
        state.vacationLocationsJson = countries
        if let firstCountryCode = state.vacationLocationsJson.first?.countryCode {
            state.vacationLocation = firstCountryCode
        }
        return .none
        
    case .searchVacationLocationsResponse(.failure):
        return .none
        
    case let .validateYear(yearString):
        guard let yearValue = Int(yearString), yearValue >= Calendar.current.component(.year, from: Date()), yearValue <= 2073 else {
            state.isYearValid = false
            return .none
        }
        state.yearSearch = yearString
        state.isYearValid = true
        return .none
        
    case let .updateYearSearch(yearString):
        state.yearSearch = yearString
        return .init(value: .validateYear(yearString))
        
    case let .updateUpcomingCurrentYearOnly(newValue):
        state.upcomingCurrentYearOnly = newValue
        if newValue {
            let currentYearStr = String(Calendar.current.component(.year, from: Date()))
            state.yearSearch = currentYearStr
            return .init(value: .validateYear(currentYearStr))
        }
        return .none
        
    case .submitSearch:
        guard state.isYearValid else { return .none }
        let searchParameters = ["selectedCountry": state.vacationLocation, "selectedYear": state.yearSearch, "upcomingCurrentYearOnly": state.upcomingCurrentYearOnly] as [String : Any]
        UserDefaults.standard.set(searchParameters, forKey: "searchParameters")
        state.isSearching = true
        return environment.networkService.fetchHolidays(state.vacationLocation, state.yearSearch, state.upcomingCurrentYearOnly)
            .receive(on: environment.mainQueue)
            .catchToEffect() { result in
                switch result {
                case let .success(holidays):
                    return .holidayList([HolidayListState(holidays: holidays)])
                case .failure:
                    return .holidayList([])
                }
            }
        
    case let .holidayList(holidayList):
        state.holidayList = holidayList
        state.isNavigatingToHolidayList = true
        return .none
        
    case let .updateVacationLocation(location):
        state.vacationLocation = location
        return .none
        
    case .resetNavigationState:
        state.isNavigatingToHolidayList = false
        return .none
    }
}
