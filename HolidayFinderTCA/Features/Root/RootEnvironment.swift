//
//  RootEnvironment.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// RootEnvironment.swift
import Foundation
import ComposableArchitecture

struct RootEnvironment {
    var holidaySearchEnvironment: HolidaySearchEnvironment
    var myVacationsEnvironment: MyVacationsEnvironment
    var myFlightsEnvironment: MyFlightsEnvironment
}

