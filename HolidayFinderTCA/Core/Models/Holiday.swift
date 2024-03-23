//
//  Holiday.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
struct Holiday: Identifiable, Codable {
    let id: UUID = UUID()
    let date: String
    let localName: String
    let name: String
    let countryCode: String
    let fixed: Bool
    let global: Bool
    let counties: [String]?
    let launchYear: Int?
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case date, localName, name, countryCode, fixed, global, counties, launchYear, types
    }
}
