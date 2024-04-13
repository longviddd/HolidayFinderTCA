//
//  HolidaySearchAction.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
import ComposableArchitecture

enum HolidaySearchAction: Equatable {
    case onAppear
    case searchVacationLocations
    case searchVacationLocationsResponse(Result<[Country], HolidaySearchError>)
    case validateYear(String)
    case updateYearSearch(String)
    case updateUpcomingCurrentYearOnly(Bool)
    case submitSearch
    case holidayList([HolidayListState])
    case updateVacationLocation(String)
    case resetNavigationState
}

enum HolidaySearchError: Error, Equatable {
    case fetchFailed
}
