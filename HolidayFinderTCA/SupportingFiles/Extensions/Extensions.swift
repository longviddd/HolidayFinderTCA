//
//  Extensions.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: self)
    }
}
extension Itinerary {
    func toDictionary() -> [String: Any] {
        return [
            "duration": duration,
            "segments": segments.map { $0.toDictionary() }
        ]
    }
}

extension Segment {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "departure": departure.toDictionary(),
            "arrival": arrival.toDictionary(),
            "carrierCode": carrierCode,
            "number": number,
            "aircraft": aircraft.toDictionary(),
            "duration": duration,
            "id": id,
            "numberOfStops": numberOfStops,
            "blacklistedInEU": blacklistedInEU
        ]
        if let operating = operating {
            dict["operating"] = operating.toDictionary()
        }
        return dict
    }
}

extension FlightEndpoint {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "iataCode": iataCode,
            "at": at
        ]
        if let terminal = terminal {
            dict["terminal"] = terminal
        }
        return dict
    }
}

extension Aircraft {
    func toDictionary() -> [String: Any] {
        return ["code": code]
    }
}

extension Operating {
    func toDictionary() -> [String: Any] {
        return ["carrierCode": carrierCode]
    }
}

extension Price {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "currency": currency,
            "total": total,
            "base": base,
            "fees": fees.map { $0.toDictionary() },
            "grandTotal": grandTotal
        ]
        if let billingCurrency = billingCurrency {
            dict["billingCurrency"] = billingCurrency
        }
        return dict
    }
}

extension Fee {
    func toDictionary() -> [String: Any] {
        return [
            "amount": amount,
            "type": type
        ]
    }
}

extension PricingOptions {
    func toDictionary() -> [String: Any] {
        return [
            "fareType": fareType,
            "includedCheckedBagsOnly": includedCheckedBagsOnly
        ]
    }
}

extension TravelerPricing {
    func toDictionary() -> [String: Any] {
        return [
            "travelerId": travelerId,
            "fareOption": fareOption,
            "travelerType": travelerType,
            "price": price.toDictionary(),
            "fareDetailsBySegment": fareDetailsBySegment.map { $0.toDictionary() }
        ]
    }
}

extension TravelerPrice {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "currency": currency,
            "total": total,
            "base": base
        ]
        if let taxes = taxes {
            dict["taxes"] = taxes.map { $0.toDictionary() }
        }
        return dict
    }
}

extension Tax {
    func toDictionary() -> [String: Any] {
        return [
            "amount": amount,
            "code": code
        ]
    }
}

extension FareDetailsBySegment {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "segmentId": segmentId,
            "cabin": cabin,
            "fareBasis": fareBasis,
            "class": `class`
        ]
        if let includedCheckedBags = includedCheckedBags {
            dict["includedCheckedBags"] = includedCheckedBags.toDictionary()
        }
        return dict
    }
}

extension IncludedCheckedBags {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let quantity = quantity {
            dict["quantity"] = quantity
        }
        if let weight = weight {
            dict["weight"] = weight
        }
        if let weightUnit = weightUnit {
            dict["weightUnit"] = weightUnit
        }
        return dict
    }
}
extension Holiday: Equatable {
    static func == (lhs: Holiday, rhs: Holiday) -> Bool {
        lhs.id == rhs.id
    }
}
extension VacationDetails: Equatable, Hashable{
    static func == (lhs: VacationDetails, rhs: VacationDetails) -> Bool {
        return lhs.originAirport == rhs.originAirport &&
            lhs.destinationAirport == rhs.destinationAirport &&
            lhs.startDate == rhs.startDate &&
            lhs.endDate == rhs.endDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(originAirport)
        hasher.combine(destinationAirport)
        hasher.combine(startDate)
        hasher.combine(endDate)
    }
}

extension FlightResponsePrice: Equatable{
    static func == (lhs: FlightResponsePrice, rhs: FlightResponsePrice) -> Bool {
        return lhs.data == rhs.data && lhs.dictionaries == rhs.dictionaries
    }
}
extension FlightResponsePriceData: Equatable{
    static func == (lhs: FlightResponsePriceData, rhs: FlightResponsePriceData) -> Bool {
        return lhs.type == rhs.type && lhs.flightOffers == rhs.flightOffers
    }
}
extension FlightOffer: Equatable, Hashable{
    static func == (lhs: FlightOffer, rhs: FlightOffer) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
extension Dictionaries: Equatable{
    static func == (lhs: Dictionaries, rhs: Dictionaries) -> Bool {
        return lhs.locations == rhs.locations &&
            lhs.aircraft == rhs.aircraft &&
            lhs.currencies == rhs.currencies &&
            lhs.carriers == rhs.carriers
    }
}
extension Location: Equatable{
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.cityCode == rhs.cityCode && lhs.countryCode == rhs.countryCode
    }
}
extension Country: Equatable{
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name &&
            lhs.countryCode == rhs.countryCode
    }
}
