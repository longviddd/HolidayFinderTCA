//
//  FlightEndPoint.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
struct FlightEndpoint: Codable {
    let iataCode: String
    let terminal: String?
    let at: String
}
