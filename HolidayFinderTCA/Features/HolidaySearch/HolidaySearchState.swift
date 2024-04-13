//
//  HolidaySearchState.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

// HolidaySearchState.swift
import Foundation
import ComposableArchitecture

struct HolidaySearchState: Equatable {
    var vacationLocation: String = ""
    var upcomingCurrentYearOnly = false
    var yearSearch = String(Calendar.current.component(.year, from: Date()))
    var vacationLocationsJson: [Country] = []
    var isYearValid = true
    var needsAirportSelection = false
    var isSearching = false
    var holidayList: [HolidayListState] = []
    var isNavigatingToHolidayList = false
}
