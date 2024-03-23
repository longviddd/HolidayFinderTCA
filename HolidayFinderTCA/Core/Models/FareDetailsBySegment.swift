//
//  FareDetailsBySegment.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
struct FareDetailsBySegment: Codable {
    let segmentId: String
    let cabin: String
    let fareBasis: String
    let `class`: String
    let includedCheckedBags: IncludedCheckedBags?
}
