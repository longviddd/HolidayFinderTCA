//
//  VacationDetails.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation

struct VacationDetails: Codable {
    var originAirport: String
    var destinationAirport: String
    var startDate: Date
    var endDate: Date
}
