//
//  FlightDetailEnvironment.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// FlightDetailEnvironment.swift
import Foundation
import ComposableArchitecture

struct FlightDetailEnvironment {
    var networkService: NetworkService
    var mainQueue: AnySchedulerOf<DispatchQueue>
}
