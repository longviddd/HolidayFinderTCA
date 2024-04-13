//
//  HolidayDetailTests.swift
//  HolidayFinderTCATests
//
//  Created by long on 2024-03-31.
//


import XCTest
import ComposableArchitecture

@testable import HolidayFinderTCA

class HolidayDetailTests: XCTestCase {
    let mockHoliday = Holiday(
        date: "2023-12-25",
        localName: "Christmas Day",
        name: "Christmas Day",
        countryCode: "US",
        fixed: true,
        global: true,
        counties: nil,
        launchYear: nil,
        types: ["Public"]
    )
    func testOnAppear() {
        let mockAirport = Airport(
            id: UUID(),
            icao: "KJFK",
            iata: "JFK",
            name: "John F. Kennedy International Airport",
            city: "New York",
            state: "New York",
            country: "United States",
            elevation: 13,
            lat: 40.639801,
            lon: -73.7789,
            tz: "America/New_York"
        )
        
        // Save the mock airport to UserDefaults
        let encoder = JSONEncoder()
        if let encodedAirport = try? encoder.encode(mockAirport) {
            UserDefaults.standard.set(encodedAirport, forKey: "selectedAirport")
        }
        
        let store = TestStore(
            initialState: HolidayDetailState(holiday: mockHoliday),
            reducer: holidayDetailReducer,
            environment: HolidayDetailEnvironment()
        )
        
        store.send(.onAppear) {
            $0.defaultOriginAirport = mockAirport.iata!
        }
    }
    
    func testAddToMyVacationList() {
        let store = TestStore(
            initialState: HolidayDetailState(holiday: mockHoliday),
            reducer: holidayDetailReducer,
            environment: HolidayDetailEnvironment()
        )
        
        store.send(.addToMyVacationList) {
            $0.showingAddHolidayModal = true
        }
    }
    
    func testDismissAddHolidayModal() {
        let store = TestStore(
            initialState: HolidayDetailState(holiday: mockHoliday, showingAddHolidayModal: true),
            reducer: holidayDetailReducer,
            environment: HolidayDetailEnvironment()
        )
        
        store.send(.dismissAddHolidayModal) {
            $0.showingAddHolidayModal = false
        }
    }
    
}
