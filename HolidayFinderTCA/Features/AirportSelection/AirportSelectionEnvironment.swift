//
//  AirportSelectionEnvironment.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// AirportSelectionEnvironment.swift
import Foundation
import ComposableArchitecture

struct AirportSelectionEnvironment {
    var networkService: NetworkService
    var mainQueue: AnySchedulerOf<DispatchQueue>
}
