//
//  HolidaySearchEnvironment.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
import ComposableArchitecture

struct HolidaySearchEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fetchVacationLocations: () -> Effect<[Country], Error>
    
}
