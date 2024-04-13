//
//  HolidayListAction.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
import ComposableArchitecture

enum HolidayListAction: Equatable {
    case onAppear
    case holidayDetail(HolidayDetailState)
}
