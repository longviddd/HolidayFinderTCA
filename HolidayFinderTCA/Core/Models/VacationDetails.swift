//
//  VacationDetails.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation

struct VacationDetails: Codable, Identifiable {
    var id : UUID
    var originAirport: String
    var destinationAirport: String
    var startDate: Date
    var endDate: Date
}
