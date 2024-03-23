//
//  HolidaySearchAction.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
import ComposableArchitecture

enum HolidaySearchAction {
    case onAppear
    case validateYearInput(String)
    case submitSearch
    case fetchVacationLocationsResponse(Result<[Country], Error>)
    case handleUpcomingCurrentYearOnlyChange(Bool)
    case setNeedsAirportSelection(Bool)
}
