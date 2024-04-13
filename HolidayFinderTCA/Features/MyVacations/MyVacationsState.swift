//
//  MyVacationsState.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
import ComposableArchitecture

struct MyVacationsState: Equatable {
    var vacations: IdentifiedArrayOf<VacationDetails> = []
    var isLoading = false
}
