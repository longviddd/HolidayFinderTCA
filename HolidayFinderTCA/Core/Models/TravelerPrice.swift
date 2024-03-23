//
//  TravelerPrice.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
struct TravelerPrice: Codable {
    let currency: String
    let total: String
    let base: String
    let taxes: [Tax]?
}
