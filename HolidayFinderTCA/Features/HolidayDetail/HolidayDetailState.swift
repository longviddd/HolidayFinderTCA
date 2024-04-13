//
//  HolidayDetailState.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

// HolidayDetailState.swift
import Foundation

struct HolidayDetailState: Equatable {
    var holiday: Holiday
    var showingAddHolidayModal = false
    var defaultOriginAirport: String = ""
}
