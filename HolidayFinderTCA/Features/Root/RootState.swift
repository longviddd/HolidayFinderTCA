//
//  RootState.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//


// RootState.swift
import Foundation
import ComposableArchitecture

enum ActiveTab {
    case holidaySearch
    case myVacations
    case myFlights
}

enum NavigationState: Equatable {
    case holidaySearch
    case holidayList(HolidayListState)
    case holidayDetail(HolidayDetailState)
    case flightSearch(FlightSearchState)
    case flightDetail(FlightDetailState)
}

struct RootState: Equatable {
    var holidaySearch = HolidaySearchState()
    var myVacations = MyVacationsState()
    var myFlights = MyFlightsState()
    var activeTab = ActiveTab.holidaySearch
    var navigationState = NavigationState.holidaySearch
}
