//
//  HolidaySearchEnvironment.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

// HolidaySearchEnvironment.swift
import Foundation
import ComposableArchitecture

struct HolidaySearchEnvironment {
    var networkService: NetworkService
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

