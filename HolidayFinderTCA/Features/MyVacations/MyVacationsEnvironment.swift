//
//  MyVacationsEnvironment.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
import ComposableArchitecture

struct MyVacationsEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}
