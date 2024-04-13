//
//  MyFlightsTests.swift
//  HolidayFinderTCATests
//
//  Created by long on 2024-03-31.
//

// MyFlightsTests.swift
import XCTest
import ComposableArchitecture

@testable import HolidayFinderTCA

class MyFlightsTests: XCTestCase {
    let mockFlightResponsePrice = FlightResponsePrice(
        data: FlightResponsePriceData(
            type: "flight-offers-pricing",
            flightOffers: [
                FlightOffer(
                    id: "1",
                    type: "flight-offer",
                    source: "GDS",
                    instantTicketingRequired: false,
                    nonHomogeneous: false,
                    oneWay: false,
                    lastTicketingDate: "2023-12-31",
                    lastTicketingDateTime: "2023-12-31T23:59:00",
                    numberOfBookableSeats: 9,
                    itineraries: [
                        Itinerary(
                            duration: "PT10H",
                            segments: [
                                Segment(
                                    departure: FlightEndpoint(iataCode: "JFK", terminal: nil, at: "2023-12-01T10:00:00"),
                                    arrival: FlightEndpoint(iataCode: "LAX", terminal: nil, at: "2023-12-01T20:00:00"),
                                    carrierCode: "AA",
                                    number: "100",
                                    aircraft: Aircraft(code: "747"),
                                    operating: nil,
                                    duration: "PT10H",
                                    id: "1",
                                    numberOfStops: 0,
                                    blacklistedInEU: nil,
                                    co2Emissions: nil
                                )
                            ]
                        ),
                        Itinerary(
                            duration: "PT10H",
                            segments: [
                                Segment(
                                    departure: FlightEndpoint(iataCode: "LAX", terminal: nil, at: "2023-12-10T10:00:00"),
                                    arrival: FlightEndpoint(iataCode: "JFK", terminal: nil, at: "2023-12-10T20:00:00"),
                                    carrierCode: "AA",
                                    number: "200",
                                    aircraft: Aircraft(code: "747"),
                                    operating: nil,
                                    duration: "PT10H",
                                    id: "2",
                                    numberOfStops: 0,
                                    blacklistedInEU: nil,
                                    co2Emissions: nil
                                )
                            ]
                        )
                    ],
                    price: Price(
                        currency: "EUR",
                        total: "1000.00",
                        base: "800.00",
                        fees: [],
                        grandTotal: "1000.00",
                        billingCurrency: nil
                    ),
                    pricingOptions: PricingOptions(
                        fareType: ["PUBLISHED"],
                        includedCheckedBagsOnly: true
                    ),
                    validatingAirlineCodes: ["AA"],
                    travelerPricings: []
                )
            ]
        ),
        dictionaries: nil
    )
    
    override func setUp() {
        super.setUp()
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "myFlights")
    }
    
    func testOnAppear() {
        let store = TestStore(
            initialState: MyFlightsState(),
            reducer: myFlightsReducer,
            environment: MyFlightsEnvironment(
                mainQueue: .immediate
            )
        )
        
        store.send(.onAppear) {
            $0.isLoading = true
        }
        store.receive(.loadSavedFlightsResponse(.success([]))) {
            $0.savedFlights = []
            $0.isLoading = false
        }
    }
    
    func testLoadSavedFlights() {
        let encoder = JSONEncoder()
        if let encodedFlightDetails = try? encoder.encode([mockFlightResponsePrice]) {
            UserDefaults.standard.set(encodedFlightDetails, forKey: "myFlights")
        }
        
        let store = TestStore(
            initialState: MyFlightsState(),
            reducer: myFlightsReducer,
            environment: MyFlightsEnvironment(
                mainQueue: .immediate
            )
        )
        
        store.send(.onAppear) {
            $0.isLoading = true
        }
        store.receive(.loadSavedFlightsResponse(.success([mockFlightResponsePrice]))) {
            $0.savedFlights = IdentifiedArray(uniqueElements: [self.mockFlightResponsePrice])
            $0.isLoading = false
        }
    }
    
    func testDeleteFlight() {
        let encoder = JSONEncoder()
        if let encodedFlightDetails = try? encoder.encode([mockFlightResponsePrice]) {
            UserDefaults.standard.set(encodedFlightDetails, forKey: "myFlights")
        }
        
        let store = TestStore(
            initialState: MyFlightsState(savedFlights: IdentifiedArray(uniqueElements: [mockFlightResponsePrice])),
            reducer: myFlightsReducer,
            environment: MyFlightsEnvironment(
                mainQueue: .immediate
            )
        )
        
        store.send(.deleteFlight(id: mockFlightResponsePrice.id)) {
            $0.savedFlights.remove(id: self.mockFlightResponsePrice.id)
        }
        
        // Assert that the flight is removed from UserDefaults
        let savedFlightsData = UserDefaults.standard.data(forKey: "myFlights")
        XCTAssertNotNil(savedFlightsData)
        
        if let data = savedFlightsData,
           let savedFlights = try? JSONDecoder().decode([FlightResponsePrice].self, from: data) {
            XCTAssertEqual(savedFlights.count, 0)
        } else {
            XCTFail("Failed to decode saved flights from UserDefaults")
        }
    }
    
    func testFlightDetail() {
        let store = TestStore(
            initialState: MyFlightsState(),
            reducer: myFlightsReducer,
            environment: MyFlightsEnvironment(
                mainQueue: .immediate
            )
        )
        
        store.send(.flightDetail(mockFlightResponsePrice.data.flightOffers[0]))
    }
}
