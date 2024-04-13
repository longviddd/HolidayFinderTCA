//
//  Airport.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation

struct Airport: Codable, Identifiable, Hashable {
    var id: UUID?
    let icao: String?
    let iata: String?
    let name: String?
    let city: String?
    let state: String?
    let country: String?
    let elevation: Int?
    let lat: Double?
    let lon: Double?
    let tz: String?
}
