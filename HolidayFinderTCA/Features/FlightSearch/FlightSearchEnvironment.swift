//
//  FlightSearchEnvironment.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// FlightSearchEnvironment.swift
import Foundation
import ComposableArchitecture

struct FlightSearchEnvironment {
    var networkService: NetworkService
    var mainQueue: AnySchedulerOf<DispatchQueue>
}
