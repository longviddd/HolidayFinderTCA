//
//  AddHolidayModalEnvironment.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
import ComposableArchitecture

struct AddHolidayModalEnvironment {
    var networkService: NetworkService
    var mainQueue: AnySchedulerOf<DispatchQueue>
}
