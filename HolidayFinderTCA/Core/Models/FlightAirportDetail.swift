//
//  FlightAirportDetail.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
struct FlightAirportDetail: Codable {
    let iataCode: String
    let terminal: String?
    let cityCode: String
    let countryCode: String

    enum CodingKeys: String, CodingKey {
        case iataCode
        case terminal
        case cityCode
        case countryCode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        iataCode = try container.decode(String.self, forKey: .iataCode)
        terminal = try container.decodeIfPresent(String.self, forKey: .terminal)

        if let locationDictionary = decoder.userInfo[CodingUserInfoKey(rawValue: "locationDictionary")!] as? [String: [String: String]] {
            let airportDetails = locationDictionary[iataCode] ?? [:]
            cityCode = airportDetails["cityCode"] ?? ""
            countryCode = airportDetails["countryCode"] ?? ""
        } else {
            cityCode = ""
            countryCode = ""
        }
    }
}
