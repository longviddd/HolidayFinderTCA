//
//  RootAction.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// RootAction.swift
import Foundation
import ComposableArchitecture

enum RootAction {
    case holidaySearch(HolidaySearchAction)
    case myVacations(MyVacationsAction)
    case myFlights(MyFlightsAction)
    case setActiveTab(ActiveTab)
    case navigate(to: NavigationState)
}

