//
//  FlightOffer.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
struct FlightOffer: Codable, Identifiable {
    let id: String
    let type: String
    let source: String
    let instantTicketingRequired: Bool
    let nonHomogeneous: Bool
    let oneWay: Bool?
    let lastTicketingDate: String
    let lastTicketingDateTime: String?
    let numberOfBookableSeats: Int?
    let itineraries: [Itinerary]
    let price: Price
    let pricingOptions: PricingOptions
    let validatingAirlineCodes: [String]
    let travelerPricings: [TravelerPricing]
}
