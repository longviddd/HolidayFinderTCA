//
//  NetworkService.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
import ComposableArchitecture

struct NetworkService {
    var fetchAirports: () -> Effect<[Airport], Never>
    var fetchAvailableCountries: () -> Effect<[Country], Error>
    var fetchHolidays: (String, String, Bool) -> Effect<[Holiday], Error>
    var fetchAuthToken: () -> Effect<String, Error>
    var fetchFlights: (String, String, String, String, Int, String) -> Effect<FlightResponse?, Error>
    var fetchFlightDetails: (FlightOffer, String) -> Effect<FlightResponsePrice?, Error>
}

extension NetworkService {
    static let live = NetworkService(
        fetchAirports: {
            Effect.task {
                let airportsURL = URL(string: "https://raw.githubusercontent.com/mwgg/Airports/master/airports.json")!
                let (data, _) = try await URLSession.shared.data(from: airportsURL)
                let airportsDict = try JSONDecoder().decode([String: Airport].self, from: data)
                return airportsDict.compactMap { (key: String, value: Airport) in
                    var airport = value
                    airport.id = airport.id ?? UUID()
                    return airport
                }
                .filter { (airport: Airport) in
                    airport.iata != nil && !(airport.iata ?? "").isEmpty && !(airport.city ?? "").isEmpty
                }
            }
            .eraseToEffect()
        },
        fetchAvailableCountries: {
            Effect.task {
                let url = URL(string: "https://date.nager.at/api/v3/AvailableCountries")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let countries = try JSONDecoder().decode([Country].self, from: data)
                return countries
            }
            .eraseToEffect()
        },
        fetchHolidays: { countryCode, year, upcomingOnly in
            Effect.task {
                let urlString = "https://date.nager.at/api/v3/PublicHolidays/\(year)/\(countryCode)"
                guard let url = URL(string: urlString) else {
                    throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
                }
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
                }
                var holidays = try JSONDecoder().decode([Holiday].self, from: data)
                if upcomingOnly {
                    let currentDate = Date()
                    holidays = holidays.filter { holiday in
                        guard let holidayDate = holiday.date.toDate() else { return false }
                        return holidayDate >= currentDate
                    }
                }
                return holidays
            }
            .eraseToEffect()
        },
        fetchAuthToken: {
            Effect.task {
                let authURL = URL(string: "https://api.amadeus.com/v1/security/oauth2/token")!
                let body = "grant_type=client_credentials&client_id=jUIvwPZ7ksDuC4IKGcNioT6ODeyjfRwz&client_secret=pQ6CG6lN0wk4Nkpk"
                var request = URLRequest(url: authURL)
                request.httpMethod = "POST"
                request.httpBody = body.data(using: .utf8)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                let (data, _) = try await URLSession.shared.data(for: request)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let accessToken = json?["access_token"] as? String else {
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                }
                return accessToken
            }
            .eraseToEffect()
        },
        fetchFlights: { originAirport, destinationAirport, departureDate, returnDate, adults, authToken in
            Effect.task {
                let flightOffersURL = URL(string: "https://api.amadeus.com/v2/shopping/flight-offers")!
                let urlString = "\(flightOffersURL)?originLocationCode=\(originAirport)&destinationLocationCode=\(destinationAirport)&departureDate=\(departureDate)&returnDate=\(returnDate)&adults=\(adults)"
                guard let url = URL(string: urlString) else {
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                }
                var request = URLRequest(url: url)
                request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                let (data, _) = try await URLSession.shared.data(for: request)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if json?["data"] != nil {
                    let flightResponse = try JSONDecoder().decode(FlightResponse.self, from: data)
                    return flightResponse
                } else {
                    return nil
                }
            }
            .eraseToEffect()
        },
        fetchFlightDetails: { selectedFlightOffer, token in
            Effect.task {
                let url = URL(string: "https://api.amadeus.com/v1/shopping/flight-offers/pricing")!
                let priceFlightOffersBody: [String: Any] = [
                    "data": [
                        "type": "flight-offers-pricing",
                        "flightOffers": [
                            [
                                "type": selectedFlightOffer.type,
                                "id": selectedFlightOffer.id,
                                "source": selectedFlightOffer.source,
                                "instantTicketingRequired": selectedFlightOffer.instantTicketingRequired,
                                "nonHomogeneous": selectedFlightOffer.nonHomogeneous,
                                "oneWay": selectedFlightOffer.oneWay,
                                "lastTicketingDate": selectedFlightOffer.lastTicketingDate,
                                "numberOfBookableSeats": selectedFlightOffer.numberOfBookableSeats,
                                "itineraries": selectedFlightOffer.itineraries.map { $0.toDictionary() },
                                "price": selectedFlightOffer.price.toDictionary(),
                                "pricingOptions": selectedFlightOffer.pricingOptions.toDictionary(),
                                "validatingAirlineCodes": selectedFlightOffer.validatingAirlineCodes,
                                "travelerPricings": selectedFlightOffer.travelerPricings.map { $0.toDictionary() }
                            ]
                        ]
                    ]
                ]
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.httpBody = try? JSONSerialization.data(withJSONObject: priceFlightOffersBody, options: [])
                let (data, _) = try await URLSession.shared.data(for: request)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if json?["data"] != nil {
                    let flightResponse = try JSONDecoder().decode(FlightResponsePrice.self, from: data)
                    print(flightResponse)
                    return flightResponse
                } else {
                    return nil
                }
            }
            .eraseToEffect()
        }
    )
}
