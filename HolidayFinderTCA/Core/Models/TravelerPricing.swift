//
//  TravelerPricing.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
struct TravelerPricing: Codable {
    let travelerId: String
    let fareOption: String
    let travelerType: String
    let price: TravelerPrice
    let fareDetailsBySegment: [FareDetailsBySegment]
}
