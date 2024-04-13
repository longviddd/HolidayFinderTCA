//
//  MyFlightsEnvironment.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// MyFlightsEnvironment.swift
import Foundation
import ComposableArchitecture

struct MyFlightsEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}
