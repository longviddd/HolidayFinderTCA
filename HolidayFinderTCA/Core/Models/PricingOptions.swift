//
//  PricingOptions.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
struct PricingOptions: Codable {
    let fareType: [String]
    let includedCheckedBagsOnly: Bool
}
