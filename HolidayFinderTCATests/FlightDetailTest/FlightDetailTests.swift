// FlightDetailTests.swift
import XCTest
import ComposableArchitecture

@testable import HolidayFinderTCA

class FlightDetailTests: XCTestCase {
    let flightOffer = FlightOffer(
        id: "1",
        type: "flight-offer",
        source: "GDS",
        instantTicketingRequired: false,
        nonHomogeneous: false,
        oneWay: false,
        lastTicketingDate: "2023-12-31",
        lastTicketingDateTime: "2023-12-31T23:59:00",
        numberOfBookableSeats: 9,
        itineraries: [],
        price: Price(
            currency: "EUR",
            total: "100.00",
            base: "80.00",
            fees: [],
            grandTotal: "100.00",
            billingCurrency: nil
        ),
        pricingOptions: PricingOptions(
            fareType: ["PUBLISHED"],
            includedCheckedBagsOnly: true
        ),
        validatingAirlineCodes: ["LH"],
        travelerPricings: []
    )
    
    func testFlightDetailOnAppear() {
        let flightOffer = FlightOffer(
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
                    duration: "PT2H",
                    segments: [
                        Segment(
                            departure: FlightEndpoint(iataCode: "JFK", terminal: "1", at: "2023-12-01T10:00:00"),
                            arrival: FlightEndpoint(iataCode: "LAX", terminal: "2", at: "2023-12-01T12:00:00"),
                            carrierCode: "AA",
                            number: "123",
                            aircraft: Aircraft(code: "320"),
                            operating: nil,
                            duration: "PT2H",
                            id: "1",
                            numberOfStops: 0,
                            blacklistedInEU: false,
                            co2Emissions: nil
                        )
                    ]
                )
            ],
            price: Price(
                currency: "EUR",
                total: "100.00",
                base: "80.00",
                fees: [],
                grandTotal: "100.00",
                billingCurrency: nil
            ),
            pricingOptions: PricingOptions(
                fareType: ["PUBLISHED"],
                includedCheckedBagsOnly: true
            ),
            validatingAirlineCodes: ["AA"],
            travelerPricings: []
        )
        
        let flightResponsePrice = FlightResponsePrice(
            data: FlightResponsePriceData(
                type: "flight-offers-pricing",
                flightOffers: [flightOffer]
            ),
            dictionaries: nil
        )
        
        let store = TestStore(
            initialState: FlightDetailState(selectedFlightOffer: flightOffer),
            reducer: flightDetailReducer,
            environment: FlightDetailEnvironment(
                networkService: .mocking(
                    fetchAuthToken: { Effect(value: "token") },
                    fetchFlightDetails: { _, _ in Effect(value: flightResponsePrice) }
                ),
                mainQueue: .immediate
            )
        )
        
        store.send(.onAppear) {
            $0.isLoading = true
        }
        store.receive(.fetchFlightDetailsResponse(.success(flightResponsePrice))) {
            $0.isLoading = false
            $0.flightDetails = flightResponsePrice
            $0.routeTitle = "Flight from JFK - LAX"
            $0.totalPrice = "100.00"
            $0.validatingCarrier = "AA"
        }
    }
    
    func testFlightDetailSuccess() {
        let flightResponsePrice = FlightResponsePrice(
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
                                        departure: FlightEndpoint(iataCode: "LHR", terminal: nil, at: "2023-12-01T10:00:00"),
                                        arrival: FlightEndpoint(iataCode: "JFK", terminal: nil, at: "2023-12-01T20:00:00"),
                                        carrierCode: "LH",
                                        number: "123",
                                        aircraft: Aircraft(code: "747"),
                                        operating: nil,
                                        duration: "PT10H",
                                        id: "1",
                                        numberOfStops: 0,
                                        blacklistedInEU: nil,
                                        co2Emissions: nil
                                    )
                                ]
                            )
                        ],
                        price: Price(
                            currency: "EUR",
                            total: "100.00",
                            base: "80.00",
                            fees: [],
                            grandTotal: "100.00",
                            billingCurrency: nil
                        ),
                        pricingOptions: PricingOptions(
                            fareType: ["PUBLISHED"],
                            includedCheckedBagsOnly: true
                        ),
                        validatingAirlineCodes: ["LH"],
                        travelerPricings: []
                    )
                ]
            ),
            dictionaries: nil
        )
        
        let store = TestStore(
            initialState: FlightDetailState(selectedFlightOffer: flightOffer),
            reducer: flightDetailReducer,
            environment: FlightDetailEnvironment(
                networkService: .mocking(
                    fetchAuthToken: { Effect(value: "token") },
                    fetchFlightDetails: { _, _ in Effect(value: flightResponsePrice) }
                ),
                mainQueue: .immediate
            )
        )
        
        store.send(.onAppear) {
            $0.isLoading = true
        }
        store.receive(.fetchFlightDetailsResponse(.success(flightResponsePrice))) {
            $0.isLoading = false
            $0.flightDetails = flightResponsePrice
            $0.routeTitle = "Flight from LHR - JFK"
            $0.totalPrice = "100.00"
            $0.validatingCarrier = "LH"
        }
    }
    
    func testSaveFlightToMyList() {
        let flightResponsePrice = FlightResponsePrice(
            data: FlightResponsePriceData(
                type: "flight-offers-pricing",
                flightOffers: [flightOffer]
            ),
            dictionaries: nil
        )
        
        let store = TestStore(
            initialState: FlightDetailState(
                flightDetails: flightResponsePrice,
                selectedFlightOffer: flightOffer
            ),
            reducer: flightDetailReducer,
            environment: FlightDetailEnvironment(
                networkService: .mocking(
                    fetchAuthToken: { Effect(value: "token") },
                    fetchFlightDetails: { _, _ in Effect(value: flightResponsePrice) }
                ),
                mainQueue: .immediate
            )
        )
        
        store.send(.saveFlightToMyList) {
            $0.alertMessage = "Flight saved successfully"
            $0.showingAlert = true
        }
    }
    
    func testAlertDismissed() {
        let store = TestStore(
            initialState: FlightDetailState(
                showingAlert: true,
                alertMessage: "Flight saved successfully",
                selectedFlightOffer: flightOffer
            ),
            reducer: flightDetailReducer,
            environment: FlightDetailEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.alertDismissed) {
            $0.showingAlert = false
        }
        store.receive(.navigateToMyFlights)
    }
}

extension NetworkService {
    static let failing = Self(
        fetchAirports: { .failing("Failing airports") },
        fetchAvailableCountries: { .failing("Failing countries") },
        fetchHolidays: { _, _, _ in .failing("Failing holidays") },
        fetchAuthToken: { .failing("Failing auth token") },
        fetchFlights: { _, _, _, _, _, _ in .failing("Failing flights") },
        fetchFlightDetails: { _, _ in .failing("Failing flight details") }
    )
    
    static func mocking(
        fetchAirports: @escaping () -> Effect<[Airport], Never> = { fatalError() },
        fetchAvailableCountries: @escaping () -> Effect<[Country], Error> = { fatalError() },
        fetchHolidays: @escaping (String, String, Bool) -> Effect<[Holiday], Error> = { _, _, _ in fatalError() },
        fetchAuthToken: @escaping () -> Effect<String, Error> = { fatalError() },
        fetchFlights: @escaping (String, String, String, String, Int, String) -> Effect<FlightResponse?, Error> = { _, _, _, _, _, _ in fatalError() },
        fetchFlightDetails: @escaping (FlightOffer, String) -> Effect<FlightResponsePrice?, Error> = { _, _ in fatalError() }
    ) -> Self {
        Self(
            fetchAirports: fetchAirports,
            fetchAvailableCountries: fetchAvailableCountries,
            fetchHolidays: fetchHolidays,
            fetchAuthToken: fetchAuthToken,
            fetchFlights: fetchFlights,
            fetchFlightDetails: fetchFlightDetails
        )
    }
}
