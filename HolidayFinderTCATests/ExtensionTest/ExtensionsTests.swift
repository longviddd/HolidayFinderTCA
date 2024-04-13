//
//  ExtensionsTests.swift
//  HolidayFinderTCATests
//
//  Created by long on 2024-04-10.
//

import XCTest
@testable import HolidayFinderTCA

class ExtensionsTests: XCTestCase {
    
    // Test String extension
    func testStringToDate() {
        let dateString = "2024-03-17"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Set time zone to UTC
        let expectedDate = dateFormatter.date(from: dateString)
        XCTAssertEqual(dateString.toDate(), expectedDate)
    }
    
    // Test Itinerary extension
    func testItineraryToDictionary() {
        let segments = [Segment(departure: FlightEndpoint(iataCode: "ABC", terminal: nil, at: "2024-03-17T10:00:00"), arrival: FlightEndpoint(iataCode: "XYZ", terminal: nil, at: "2024-03-17T12:00:00"), carrierCode: "AA", number: "123", aircraft: Aircraft(code: "747"), operating: nil, duration: "PT2H", id: "1", numberOfStops: 0, blacklistedInEU: false, co2Emissions: nil)]
        let itinerary = Itinerary(duration: "PT2H", segments: segments)
        let expectedDict: [String: Any] = [
            "duration": "PT2H",
            "segments": [
                [
                    "departure": ["iataCode": "ABC", "at": "2024-03-17T10:00:00"],
                    "arrival": ["iataCode": "XYZ", "at": "2024-03-17T12:00:00"],
                    "carrierCode": "AA",
                    "number": "123",
                    "aircraft": ["code": "747"],
                    "duration": "PT2H",
                    "id": "1",
                    "numberOfStops": 0,
                    "blacklistedInEU": false
                ]
            ]
        ]
        XCTAssertEqual(itinerary.toDictionary() as NSDictionary, expectedDict as NSDictionary)
    }
    
    // Test Segment extension
    func testSegmentToDictionary() {
        let segment = Segment(departure: FlightEndpoint(iataCode: "ABC", terminal: nil, at: "2024-03-17T10:00:00"), arrival: FlightEndpoint(iataCode: "XYZ", terminal: nil, at: "2024-03-17T12:00:00"), carrierCode: "AA", number: "123", aircraft: Aircraft(code: "747"), operating: Operating(carrierCode: "BB"), duration: "PT2H", id: "1", numberOfStops: 0, blacklistedInEU: false, co2Emissions: nil)
        let expectedDict: [String: Any] = [
            "departure": ["iataCode": "ABC", "at": "2024-03-17T10:00:00"],
            "arrival": ["iataCode": "XYZ", "at": "2024-03-17T12:00:00"],
            "carrierCode": "AA",
            "number": "123",
            "aircraft": ["code": "747"],
            "operating": ["carrierCode": "BB"],
            "duration": "PT2H",
            "id": "1",
            "numberOfStops": 0,
            "blacklistedInEU": false
        ]
        XCTAssertEqual(segment.toDictionary() as NSDictionary, expectedDict as NSDictionary)
    }
    
    // Test FlightEndpoint extension
    func testFlightEndpointToDictionary() {
        let flightEndpoint = FlightEndpoint(iataCode: "ABC", terminal: "T1", at: "2024-03-17T10:00:00")
        let expectedDict: [String: Any] = [
            "iataCode": "ABC",
            "terminal": "T1",
            "at": "2024-03-17T10:00:00"
        ]
        XCTAssertEqual(flightEndpoint.toDictionary() as NSDictionary, expectedDict as NSDictionary)
    }
    
    // Test Aircraft extension
    func testAircraftToDictionary() {
        let aircraft = Aircraft(code: "747")
        let expectedDict: [String: Any] = [
            "code": "747"
        ]
        XCTAssertEqual(aircraft.toDictionary() as NSDictionary, expectedDict as NSDictionary)
    }
    
    // Test Operating extension
    func testOperatingToDictionary() {
        let operating = Operating(carrierCode: "AA")
        let expectedDict: [String: Any] = [
            "carrierCode": "AA"
        ]
        XCTAssertEqual(operating.toDictionary() as NSDictionary, expectedDict as NSDictionary)
    }
    
    // Test Price extension
    func testPriceToDictionary() {
        let fees = [Fee(amount: "10", type: "TICKETING")]
        let price = Price(currency: "USD", total: "100", base: "90", fees: fees, grandTotal: "110", billingCurrency: "EUR")
        let expectedDict: [String: Any] = [
            "currency": "USD",
            "total": "100",
            "base": "90",
            "fees": [
                [
                    "amount": "10",
                    "type": "TICKETING"
                ]
            ],
            "grandTotal": "110",
            "billingCurrency": "EUR"
        ]
        XCTAssertEqual(price.toDictionary() as NSDictionary, expectedDict as NSDictionary)
    }
    
    // Test Fee extension
    func testFeeToDictionary() {
        let fee = Fee(amount: "10", type: "TICKETING")
        let expectedDict: [String: Any] = [
            "amount": "10",
            "type": "TICKETING"
        ]
        XCTAssertEqual(fee.toDictionary() as NSDictionary, expectedDict as NSDictionary)
    }
    
    // Test PricingOptions extension
    func testPricingOptionsToDictionary() {
        let pricingOptions = PricingOptions(fareType: ["PUBLISHED"], includedCheckedBagsOnly: true)
        let expectedDict: [String: Any] = [
            "fareType": ["PUBLISHED"],
            "includedCheckedBagsOnly": true
        ]
        XCTAssertEqual(pricingOptions.toDictionary() as NSDictionary, expectedDict as NSDictionary)
    }
    
    // Test TravelerPricing extension
    func testTravelerPricingToDictionary() {
        let travelerPrice = TravelerPrice(currency: "USD", total: "100", base: "90", taxes: nil)
        let fareDetailsBySegment = [FareDetailsBySegment(segmentId: "1", cabin: "ECONOMY", fareBasis: "ABC123", class: "Y", includedCheckedBags: nil)]
        let travelerPricing = TravelerPricing(travelerId: "1", fareOption: "STANDARD", travelerType: "ADULT", price: travelerPrice, fareDetailsBySegment: fareDetailsBySegment)
        let expectedDict: [String: Any] = [
            "travelerId": "1",
            "fareOption": "STANDARD",
            "travelerType": "ADULT",
            "price": [
                "currency": "USD",
                "total": "100",
                "base": "90"
            ],
            "fareDetailsBySegment": [
                [
                    "segmentId": "1",
                    "cabin": "ECONOMY",
                    "fareBasis": "ABC123",
                    "class": "Y"
                ]
            ]
        ]
        XCTAssertEqual(travelerPricing.toDictionary() as NSDictionary, expectedDict as NSDictionary)
    }
    
    // Test TravelerPrice extension
    func testTravelerPriceToDictionary() {
        let taxes = [Tax(amount: "10", code: "TAX")]
        let travelerPrice = TravelerPrice(currency: "USD", total: "100", base: "90", taxes: taxes)
        let expectedDict: [String: Any] = [
            "currency": "USD",
            "total": "100",
            "base": "90",
            "taxes": [
                [
                    "amount": "10",
                    "code": "TAX"
                ]
            ]
        ]
        XCTAssertEqual(travelerPrice.toDictionary() as NSDictionary, expectedDict as NSDictionary)
    }
    
    // Test Tax extension
    func testTaxToDictionary() {
        let tax = Tax(amount: "10", code: "TAX")
        let expectedDict: [String: Any] = [
            "amount": "10",
            "code": "TAX"
        ]
        XCTAssertEqual(tax.toDictionary() as NSDictionary, expectedDict as NSDictionary)
    }
    
    // Test FareDetailsBySegment extension
    func testFareDetailsBySegmentToDictionary() {
        let includedCheckedBags = IncludedCheckedBags(quantity: 1, weight: 23, weightUnit: "KG")
        let fareDetailsBySegment = FareDetailsBySegment(segmentId: "1", cabin: "ECONOMY", fareBasis: "ABC123", class: "Y", includedCheckedBags: includedCheckedBags)
        let expectedDict: [String: Any] = [
            "segmentId": "1",
            "cabin": "ECONOMY",
            "fareBasis": "ABC123",
            "class": "Y",
            "includedCheckedBags": [
                "quantity": 1,
                "weight": 23,
                "weightUnit": "KG"
            ]
        ]
        XCTAssertEqual(fareDetailsBySegment.toDictionary() as NSDictionary, expectedDict as NSDictionary)
    }
    
    // Test IncludedCheckedBags extension
    func testIncludedCheckedBagsToDictionary() {
        let includedCheckedBags = IncludedCheckedBags(quantity: 1, weight: 23, weightUnit: "KG")
        let expectedDict: [String: Any] = [
            "quantity": 1,
            "weight": 23,
            "weightUnit": "KG"
        ]
        XCTAssertEqual(includedCheckedBags.toDictionary() as NSDictionary, expectedDict as NSDictionary)
    }
    
    // Test Holiday extension
    func testHolidayEquality() {
        let holiday1 = Holiday(date: "2024-03-17", localName: "Local Holiday", name: "Holiday", countryCode: "US", fixed: true, global: true, counties: nil, launchYear: nil, types: ["Public"])
        let holiday2 = Holiday(date: "2024-03-17", localName: "Local Holiday", name: "Holiday", countryCode: "US", fixed: true, global: true, counties: nil, launchYear: nil, types: ["Public"])
        XCTAssertEqual(holiday1, holiday2)
        
        let holiday3 = Holiday(date: "2024-03-18", localName: "Local Holiday", name: "Holiday", countryCode: "US", fixed: true, global: true, counties: nil, launchYear: nil, types: ["Public"])
        XCTAssertNotEqual(holiday1, holiday3)
    }
    
    // Test VacationDetails extension
    func testVacationDetailsEquality() {
        let vacationDetails1 = VacationDetails(id: UUID.mockGenerate(), originAirport: "ABC", destinationAirport: "XYZ", startDate: Date(), endDate: Date())
        let vacationDetails2 = VacationDetails(id: UUID.mockGenerate(), originAirport: "ABC", destinationAirport: "XYZ", startDate: Date(), endDate: Date())
        XCTAssertEqual(vacationDetails1, vacationDetails2)
        
        let vacationDetails3 = VacationDetails(id: UUID(), originAirport: "DEF", destinationAirport: "XYZ", startDate: Date(), endDate: Date())
        XCTAssertNotEqual(vacationDetails1, vacationDetails3)
    }
    
    // Test FlightResponsePrice extension
    func testFlightResponsePriceEquality() {
        let flightResponsePriceData1 = FlightResponsePriceData(type: "flight-offers-pricing", flightOffers: [])
        let flightResponsePrice1 = FlightResponsePrice( data: flightResponsePriceData1, dictionaries: nil)
        
        let flightResponsePriceData2 = FlightResponsePriceData(type: "flight-offers-pricing", flightOffers: [])
        let flightResponsePrice2 = FlightResponsePrice( data: flightResponsePriceData2, dictionaries: nil)
        
        XCTAssertEqual(flightResponsePrice1, flightResponsePrice2)
        
        let flightResponsePriceData3 = FlightResponsePriceData(type: "flight-offers", flightOffers: [])
        let flightResponsePrice3 = FlightResponsePrice( data: flightResponsePriceData3, dictionaries: nil)
        
        XCTAssertNotEqual(flightResponsePrice1, flightResponsePrice3)
    }
    
    // Test FlightResponsePriceData extension
    func testFlightResponsePriceDataEquality() {
        let flightOffer = FlightOffer(id: "1", type: "flight-offer", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: false, lastTicketingDate: "2024-03-17", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: [], price: Price(currency: "USD", total: "100", base: "90", fees: [], grandTotal: "110", billingCurrency: nil), pricingOptions: PricingOptions(fareType: ["PUBLISHED"], includedCheckedBagsOnly: true), validatingAirlineCodes: ["AA"], travelerPricings: [])
        
        let flightResponsePriceData1 = FlightResponsePriceData(type: "flight-offers-pricing", flightOffers: [flightOffer])
        let flightResponsePriceData2 = FlightResponsePriceData(type: "flight-offers-pricing", flightOffers: [flightOffer])
        
        XCTAssertEqual(flightResponsePriceData1, flightResponsePriceData2)
        
        let flightResponsePriceData3 = FlightResponsePriceData(type: "flight-offers", flightOffers: [flightOffer])
        
        XCTAssertNotEqual(flightResponsePriceData1, flightResponsePriceData3)
    }
    
    // Test FlightOffer extension
    func testFlightOfferHashable() {
        let flightOffer1 = FlightOffer(id: "1", type: "flight-offer", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: false, lastTicketingDate: "2024-03-17", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: [], price: Price(currency: "USD", total: "100", base: "90", fees: [], grandTotal: "110", billingCurrency: nil), pricingOptions: PricingOptions(fareType: ["PUBLISHED"], includedCheckedBagsOnly: true), validatingAirlineCodes: ["AA"], travelerPricings: [])
        
        let flightOffer2 = FlightOffer(id: "1", type: "flight-offer", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: false, lastTicketingDate: "2024-03-17", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: [], price: Price(currency: "USD", total: "100", base: "90", fees: [], grandTotal: "110", billingCurrency: nil), pricingOptions: PricingOptions(fareType: ["PUBLISHED"], includedCheckedBagsOnly: true), validatingAirlineCodes: ["AA"], travelerPricings: [])
        XCTAssertEqual(flightOffer1.hashValue, flightOffer2.hashValue)
        
        let flightOffer3 = FlightOffer(id: "2", type: "flight-offer", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: false, lastTicketingDate: "2024-03-17", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: [], price: Price(currency: "USD", total: "100", base: "90", fees: [], grandTotal: "110", billingCurrency: nil), pricingOptions: PricingOptions(fareType: ["PUBLISHED"], includedCheckedBagsOnly: true), validatingAirlineCodes: ["AA"], travelerPricings: [])
        
        XCTAssertNotEqual(flightOffer1.hashValue, flightOffer3.hashValue)
    }
    
    // Test Country extension
    func testCountryEquality() {
        let country1 = Country(name: "United States", countryCode: "US")
        let country2 = Country(name: "United States", countryCode: "US")
        XCTAssertEqual(country1, country2)
        
        let country3 = Country(name: "Canada", countryCode: "CA")
        XCTAssertNotEqual(country1, country3)
    }
    
    // Test Flight extension
    func testFlightEquality() {
        let flight1 = Flight(outboundOriginAirport: "ABC", outboundDestinationAirport: "XYZ", outboundDuration: "PT2H", returnOriginAirport: "XYZ", returnDestinationAirport: "ABC", returnDuration: "PT2H", price: 100.0)
        let flight2 = Flight(outboundOriginAirport: "ABC", outboundDestinationAirport: "XYZ", outboundDuration: "PT2H", returnOriginAirport: "XYZ", returnDestinationAirport: "ABC", returnDuration: "PT2H", price: 100.0)
        XCTAssertEqual(flight1, flight2)
        
        let flight3 = Flight(outboundOriginAirport: "DEF", outboundDestinationAirport: "XYZ", outboundDuration: "PT2H", returnOriginAirport: "XYZ", returnDestinationAirport: "ABC", returnDuration: "PT2H", price: 100.0)
        XCTAssertNotEqual(flight1, flight3)
    }
    
    // Test FlightResponse extension
    func testFlightResponseEquality() {
        let meta = Meta(count: 1, links: Links(self: "https://example.com"))
        let flightOffer = FlightOffer(id: "1", type: "flight-offer", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: false, lastTicketingDate: "2024-03-17", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: [], price: Price(currency: "USD", total: "100", base: "90", fees: [], grandTotal: "110", billingCurrency: nil), pricingOptions: PricingOptions(fareType: ["PUBLISHED"], includedCheckedBagsOnly: true), validatingAirlineCodes: ["AA"], travelerPricings: [])
        let dictionaries = Dictionaries(locations: ["ABC": Location(cityCode: "NYC", countryCode: "US")], aircraft: nil, currencies: nil, carriers: nil)
        
        let flightResponse1 = FlightResponse(meta: meta, data: [flightOffer], dictionaries: dictionaries)
        let flightResponse2 = FlightResponse(meta: meta, data: [flightOffer], dictionaries: dictionaries)
        XCTAssertEqual(flightResponse1, flightResponse2)
        
        let flightResponse3 = FlightResponse(meta: nil, data: [flightOffer], dictionaries: dictionaries)
        XCTAssertNotEqual(flightResponse1, flightResponse3)
    }
    
    // Test Meta extension
    func testMetaEquality() {
        let meta1 = Meta(count: 1, links: Links(self: "https://example.com"))
        let meta2 = Meta(count: 1, links: Links(self: "https://example.com"))
        XCTAssertEqual(meta1, meta2)
        
        let meta3 = Meta(count: 2, links: Links(self: "https://example.com"))
        XCTAssertNotEqual(meta1, meta3)
    }
    
    // Test Links extension
    func testLinksEquality() {
        let links1 = Links(self: "https://example.com")
        let links2 = Links(self: "https://example.com")
        XCTAssertEqual(links1, links2)
        
        let links3 = Links(self: "https://example.org")
        XCTAssertNotEqual(links1, links3)
    }
    
    // Test FlightOffer extension
    func testFlightOfferEquality() {
        let itineraries = [Itinerary(duration: "PT2H", segments: [])]
        let price = Price(currency: "USD", total: "100", base: "90", fees: [], grandTotal: "110", billingCurrency: nil)
        let pricingOptions = PricingOptions(fareType: ["PUBLISHED"], includedCheckedBagsOnly: true)
        let travelerPricings = [TravelerPricing(travelerId: "1", fareOption: "STANDARD", travelerType: "ADULT", price: TravelerPrice(currency: "USD", total: "100", base: "90", taxes: nil), fareDetailsBySegment: [])]
        
        let flightOffer1 = FlightOffer(id: "1", type: "flight-offer", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: false, lastTicketingDate: "2024-03-17", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: itineraries, price: price, pricingOptions: pricingOptions, validatingAirlineCodes: ["AA"], travelerPricings: travelerPricings)
        let flightOffer2 = FlightOffer(id: "1", type: "flight-offer", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: false, lastTicketingDate: "2024-03-17", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: itineraries, price: price, pricingOptions: pricingOptions, validatingAirlineCodes: ["AA"], travelerPricings: travelerPricings)
        XCTAssertEqual(flightOffer1, flightOffer2)
        
        let flightOffer3 = FlightOffer(id: "2", type: "flight-offer", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: false, lastTicketingDate: "2024-03-17", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: itineraries, price: price, pricingOptions: pricingOptions, validatingAirlineCodes: ["AA"], travelerPricings: travelerPricings)
        XCTAssertNotEqual(flightOffer1, flightOffer3)
    }
    // Test Itinerary extension
    func testItineraryEquality() {
        let segments = [Segment(departure: FlightEndpoint(iataCode: "ABC", terminal: nil, at: "2024-03-17T10:00:00"), arrival: FlightEndpoint(iataCode: "XYZ", terminal: nil, at: "2024-03-17T12:00:00"), carrierCode: "AA", number: "123", aircraft: Aircraft(code: "747"), operating: nil, duration: "PT2H", id: "1", numberOfStops: 0, blacklistedInEU: false, co2Emissions: nil)]
        
        let itinerary1 = Itinerary(duration: "PT2H", segments: segments)
        let itinerary2 = Itinerary(duration: "PT2H", segments: segments)
        XCTAssertEqual(itinerary1, itinerary2)
        
        let itinerary3 = Itinerary(duration: "PT3H", segments: segments)
        XCTAssertNotEqual(itinerary1, itinerary3)
    }
    
    // Test Segment extension
    func testSegmentEquality() {
        let segment1 = Segment(departure: FlightEndpoint(iataCode: "ABC", terminal: nil, at: "2024-03-17T10:00:00"), arrival: FlightEndpoint(iataCode: "XYZ", terminal: nil, at: "2024-03-17T12:00:00"), carrierCode: "AA", number: "123", aircraft: Aircraft(code: "747"), operating: nil, duration: "PT2H", id: "1", numberOfStops: 0, blacklistedInEU: false, co2Emissions: nil)
        let segment2 = Segment(departure: FlightEndpoint(iataCode: "ABC", terminal: nil, at: "2024-03-17T10:00:00"), arrival: FlightEndpoint(iataCode: "XYZ", terminal: nil, at: "2024-03-17T12:00:00"), carrierCode: "AA", number: "123", aircraft: Aircraft(code: "747"), operating: nil, duration: "PT2H", id: "1", numberOfStops: 0, blacklistedInEU: false, co2Emissions: nil)
        XCTAssertEqual(segment1, segment2)
        
        let segment3 = Segment(departure: FlightEndpoint(iataCode: "DEF", terminal: nil, at: "2024-03-17T10:00:00"), arrival: FlightEndpoint(iataCode: "XYZ", terminal: nil, at: "2024-03-17T12:00:00"), carrierCode: "AA", number: "123", aircraft: Aircraft(code: "747"), operating: nil, duration: "PT2H", id: "1", numberOfStops: 0, blacklistedInEU: false, co2Emissions: nil)
        XCTAssertNotEqual(segment1, segment3)
    }
    
    // Test FlightEndpoint extension
    func testFlightEndpointEquality() {
        let flightEndpoint1 = FlightEndpoint(iataCode: "ABC", terminal: "T1", at: "2024-03-17T10:00:00")
        let flightEndpoint2 = FlightEndpoint(iataCode: "ABC", terminal: "T1", at: "2024-03-17T10:00:00")
        XCTAssertEqual(flightEndpoint1, flightEndpoint2)
        
        let flightEndpoint3 = FlightEndpoint(iataCode: "XYZ", terminal: "T2", at: "2024-03-17T10:00:00")
        XCTAssertNotEqual(flightEndpoint1, flightEndpoint3)
    }
    
    // Test Aircraft extension
    func testAircraftEquality() {
        let aircraft1 = Aircraft(code: "747")
        let aircraft2 = Aircraft(code: "747")
        XCTAssertEqual(aircraft1, aircraft2)
        
        let aircraft3 = Aircraft(code: "737")
        XCTAssertNotEqual(aircraft1, aircraft3)
    }
    
    // Test Operating extension
    func testOperatingEquality() {
        let operating1 = Operating(carrierCode: "AA")
        let operating2 = Operating(carrierCode: "AA")
        XCTAssertEqual(operating1, operating2)
        
        let operating3 = Operating(carrierCode: "BA")
        XCTAssertNotEqual(operating1, operating3)
    }
    
    // Test Price extension
    func testPriceEquality() {
        let fees = [Fee(amount: "10", type: "TICKETING")]
        
        let price1 = Price(currency: "USD", total: "100", base: "90", fees: fees, grandTotal: "110", billingCurrency: "EUR")
        let price2 = Price(currency: "USD", total: "100", base: "90", fees: fees, grandTotal: "110", billingCurrency: "EUR")
        XCTAssertEqual(price1, price2)
        
        let price3 = Price(currency: "GBP", total: "80", base: "70", fees: fees, grandTotal: "90", billingCurrency: "GBP")
        XCTAssertNotEqual(price1, price3)
    }
    
    // Test Fee extension
    func testFeeEquality() {
        let fee1 = Fee(amount: "10", type: "TICKETING")
        let fee2 = Fee(amount: "10", type: "TICKETING")
        XCTAssertEqual(fee1, fee2)
        
        let fee3 = Fee(amount: "20", type: "BAGGAGE")
        XCTAssertNotEqual(fee1, fee3)
    }
    
    // Test Dictionaries extension
    func testDictionariesEquality() {
        let locations = ["ABC": Location(cityCode: "NYC", countryCode: "US")]
        let aircraft = ["747": "Boeing 747"]
        let currencies = ["USD": "US Dollar"]
        let carriers = ["AA": "American Airlines"]
        
        let dictionaries1 = Dictionaries(locations: locations, aircraft: aircraft, currencies: currencies, carriers: carriers)
        let dictionaries2 = Dictionaries(locations: locations, aircraft: aircraft, currencies: currencies, carriers: carriers)
        XCTAssertEqual(dictionaries1, dictionaries2)
        
        let dictionaries3 = Dictionaries(locations: locations, aircraft: nil, currencies: nil, carriers: nil)
        XCTAssertNotEqual(dictionaries1, dictionaries3)
    }
    
    // Test Location extension
    func testLocationEquality() {
        let location1 = Location(cityCode: "NYC", countryCode: "US")
        let location2 = Location(cityCode: "NYC", countryCode: "US")
        XCTAssertEqual(location1, location2)
        
        let location3 = Location(cityCode: "LON", countryCode: "GB")
        XCTAssertNotEqual(location1, location3)
    }
    
    // Test PricingOptions extension
    func testPricingOptionsEquality() {
        let pricingOptions1 = PricingOptions(fareType: ["PUBLISHED"], includedCheckedBagsOnly: true)
        let pricingOptions2 = PricingOptions(fareType: ["PUBLISHED"], includedCheckedBagsOnly: true)
        XCTAssertEqual(pricingOptions1, pricingOptions2)
        
        let pricingOptions3 = PricingOptions(fareType: ["PRIVATE"], includedCheckedBagsOnly: false)
        XCTAssertNotEqual(pricingOptions1, pricingOptions3)
    }
    
    // Test TravelerPricing extension
    func testTravelerPricingEquality() {
        let travelerPrice = TravelerPrice(currency: "USD", total: "100", base: "90", taxes: nil)
        let fareDetailsBySegment = [FareDetailsBySegment(segmentId: "1", cabin: "ECONOMY", fareBasis: "ABC123", class: "Y", includedCheckedBags: nil)]
        
        let travelerPricing1 = TravelerPricing(travelerId: "1", fareOption: "STANDARD", travelerType: "ADULT", price: travelerPrice, fareDetailsBySegment: fareDetailsBySegment)
        let travelerPricing2 = TravelerPricing(travelerId: "1", fareOption: "STANDARD", travelerType: "ADULT", price: travelerPrice, fareDetailsBySegment: fareDetailsBySegment)
        XCTAssertEqual(travelerPricing1, travelerPricing2)
        
        let travelerPricing3 = TravelerPricing(travelerId: "2", fareOption: "STANDARD", travelerType: "CHILD", price: travelerPrice, fareDetailsBySegment: fareDetailsBySegment)
        XCTAssertNotEqual(travelerPricing1, travelerPricing3)
    }
    
    // Test TravelerPrice extension
    func testTravelerPriceEquality() {
        let taxes = [Tax(amount: "10", code: "TAX")]
        
        let travelerPrice1 = TravelerPrice(currency: "USD", total: "100", base: "90", taxes: taxes)
        let travelerPrice2 = TravelerPrice(currency: "USD", total: "100", base: "90", taxes: taxes)
        XCTAssertEqual(travelerPrice1, travelerPrice2)
        
        let travelerPrice3 = TravelerPrice(currency: "GBP", total: "80", base: "70", taxes: taxes)
        XCTAssertNotEqual(travelerPrice1, travelerPrice3)
    }
    
    // Test Tax extension
    func testTaxEquality() {
        let tax1 = Tax(amount: "10", code: "TAX")
        let tax2 = Tax(amount: "10", code: "TAX")
        XCTAssertEqual(tax1, tax2)
        
        let tax3 = Tax(amount: "20", code: "FEE")
        XCTAssertNotEqual(tax1, tax3)
    }
    
    // Test FareDetailsBySegment extension
    func testFareDetailsBySegmentEquality() {
        let includedCheckedBags = IncludedCheckedBags(quantity: 1, weight: 23, weightUnit: "KG")
        
        let fareDetailsBySegment1 = FareDetailsBySegment(segmentId: "1", cabin: "ECONOMY", fareBasis: "ABC123", class: "Y", includedCheckedBags: includedCheckedBags)
        let fareDetailsBySegment2 = FareDetailsBySegment(segmentId: "1", cabin: "ECONOMY", fareBasis: "ABC123", class: "Y", includedCheckedBags: includedCheckedBags)
        XCTAssertEqual(fareDetailsBySegment1, fareDetailsBySegment2)
        
        let fareDetailsBySegment3 = FareDetailsBySegment(segmentId: "2", cabin: "BUSINESS", fareBasis: "XYZ789", class: "C", includedCheckedBags: nil)
        XCTAssertNotEqual(fareDetailsBySegment1, fareDetailsBySegment3)
    }
    
    // Test IncludedCheckedBags extension
    func testIncludedCheckedBagsEquality() {
        let includedCheckedBags1 = IncludedCheckedBags(quantity: 1, weight: 23, weightUnit: "KG")
        let includedCheckedBags2 = IncludedCheckedBags(quantity: 1, weight: 23, weightUnit: "KG")
        XCTAssertEqual(includedCheckedBags1, includedCheckedBags2)
        
        let includedCheckedBags3 = IncludedCheckedBags(quantity: 2, weight: 32, weightUnit: "LB")
        XCTAssertNotEqual(includedCheckedBags1, includedCheckedBags3)
    }
    
    // Test co2Emission extension
    func testCo2EmissionEquality() {
        let co2Emission1 = co2Emission(weight: 100, weightUnit: "KG", cabin: "ECONOMY")
        let co2Emission2 = co2Emission(weight: 100, weightUnit: "KG", cabin: "ECONOMY")
        XCTAssertEqual(co2Emission1, co2Emission2)
        
        let co2Emission3 = co2Emission(weight: 150, weightUnit: "LB", cabin: "BUSINESS")
        XCTAssertNotEqual(co2Emission1, co2Emission3)
    }
    
    // Test SaveStatus extension
    func testSaveStatusEquality() {
        let saveStatus1: SaveStatus = .success
        let saveStatus2: SaveStatus = .success
        XCTAssertEqual(saveStatus1, saveStatus2)
        
        let saveStatus3: SaveStatus = .failure
        XCTAssertNotEqual(saveStatus1, saveStatus3)
    }
}
