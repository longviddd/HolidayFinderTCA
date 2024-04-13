//
//  AddHolidayModalTests.swift
//  HolidayFinderTCATests
//
//  Created by long on 2024-03-31.
//

// AddHolidayModalTests.swift
import XCTest
import ComposableArchitecture

@testable import HolidayFinderTCA

class AddHolidayModalTests: XCTestCase {
    let mockAirports = [
        Airport(id: UUID(), icao: "KJFK", iata: "JFK", name: "John F. Kennedy International Airport", city: "New York", state: "New York", country: "United States", elevation: 13, lat: 40.639801, lon: -73.7789, tz: "America/New_York"),
        Airport(id: UUID(), icao: "KLAX", iata: "LAX", name: "Los Angeles International Airport", city: "Los Angeles", state: "California", country: "United States", elevation: 125, lat: 33.9425, lon: -118.408005, tz: "America/Los_Angeles")
    ]
    
    override func setUp() {
        super.setUp()
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "vacationList")
    }
    
    func testOnAppear() {
        let initialStartDate = Date()
        
        let store = TestStore(
            initialState: AddHolidayModalState(),
            reducer: addHolidayModalReducer,
            environment: AddHolidayModalEnvironment(
                networkService: .mocking(
                    fetchAirports: { Effect(value: self.mockAirports) }
                ),
                mainQueue: .immediate
            )
        )
        
        store.send(.onAppear(initialStartDate: initialStartDate)) {
            $0.isLoading = true
            $0.startDate = initialStartDate
            $0.endDate = Calendar.current.date(byAdding: .day, value: 1, to: initialStartDate) ?? initialStartDate
        }
        store.receive(.fetchAirportsResponse(.success(mockAirports))) {
            $0.isLoading = false
            $0.airports = IdentifiedArrayOf(uniqueElements: self.mockAirports)
            $0.filteredAirports = $0.airports
        }
    }
    
    func testSearchAirports() {
        let store = TestStore(
            initialState: AddHolidayModalState(
                airports: IdentifiedArrayOf(uniqueElements: mockAirports),
                filteredAirports: IdentifiedArrayOf(uniqueElements: mockAirports)
            ),
            reducer: addHolidayModalReducer,
            environment: AddHolidayModalEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.searchAirports(query: "JFK")) {
            $0.searchQuery = "JFK"
            $0.filteredAirports = IdentifiedArrayOf(uniqueElements: [self.mockAirports[0]])
        }
    }
    
    func testSelectAirport() {
        let store = TestStore(
            initialState: AddHolidayModalState(),
            reducer: addHolidayModalReducer,
            environment: AddHolidayModalEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.selectAirport(mockAirports[0], isOrigin: true)) {
            $0.originAirport = self.mockAirports[0].iata!
            $0.selectedAirport = self.mockAirports[0]
        }
        
        store.send(.selectAirport(mockAirports[1], isOrigin: false)) {
            $0.destinationAirport = self.mockAirports[1].iata!
            $0.selectedAirport = self.mockAirports[1]
        }
    }
    
    func testShowAirportSelection() {
        let store = TestStore(
            initialState: AddHolidayModalState(
                airports: IdentifiedArrayOf(uniqueElements: mockAirports),
                filteredAirports: IdentifiedArrayOf(uniqueElements: mockAirports)
            ),
            reducer: addHolidayModalReducer,
            environment: AddHolidayModalEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.showAirportSelection(isOrigin: true)) {
            $0.searchQuery = ""
            $0.filteredAirports = $0.airports
            $0.showAirportSelection = true
            $0.selectedAirport = nil
        }
    }
    
    func testHideAirportSelection() {
        let store = TestStore(
            initialState: AddHolidayModalState(showAirportSelection: true),
            reducer: addHolidayModalReducer,
            environment: AddHolidayModalEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.hideAirportSelection) {
            $0.showAirportSelection = false
        }
    }
    
    func testSetStartDate() {
        let store = TestStore(
            initialState: AddHolidayModalState(),
            reducer: addHolidayModalReducer,
            environment: AddHolidayModalEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        let startDate = Date()
        store.send(.setStartDate(startDate)) {
            $0.startDate = startDate
            $0.endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        }
    }
    
    func testSetEndDate() {
        let store = TestStore(
            initialState: AddHolidayModalState(),
            reducer: addHolidayModalReducer,
            environment: AddHolidayModalEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        let endDate = Date()
        store.send(.setEndDate(endDate)) {
            $0.endDate = endDate
        }
    }
    
    func testNextStep() {
        let store = TestStore(
            initialState: AddHolidayModalState(currentStep: 1),
            reducer: addHolidayModalReducer,
            environment: AddHolidayModalEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.nextStep) {
            $0.currentStep = 2
        }
    }
    
    func testPreviousStep() {
        let store = TestStore(
            initialState: AddHolidayModalState(currentStep: 2),
            reducer: addHolidayModalReducer,
            environment: AddHolidayModalEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.previousStep) {
            $0.currentStep = 1
        }
    }
    
    func testSaveVacation() {
        let store = TestStore(
            initialState: AddHolidayModalState(
                originAirport: "JFK",
                destinationAirport: "LAX",
                startDate: Date(),
                endDate: Date()
            ),
            reducer: addHolidayModalReducer,
            environment: AddHolidayModalEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.saveVacation)
        store.receive(.savingStatus(.success)) {
            $0.saveStatus = .success
        }
        store.receive(.navigateToMyVacations)
        
        // Assert that the vacation is saved to UserDefaults
        let savedVacationsData = UserDefaults.standard.data(forKey: "vacationList")
        XCTAssertNotNil(savedVacationsData)
        
        if let data = savedVacationsData,
           let savedVacations = try? JSONDecoder().decode([VacationDetails].self, from: data) {
            XCTAssertEqual(savedVacations.count, 1)
        } else {
            XCTFail("Failed to decode saved vacations from UserDefaults")
        }
    }
    
    func testSavingStatus() {
        let store = TestStore(
            initialState: AddHolidayModalState(),
            reducer: addHolidayModalReducer,
            environment: AddHolidayModalEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.savingStatus(.success)) {
            $0.saveStatus = .success
        }
        
        store.send(.savingStatus(.failure)) {
            $0.saveStatus = .failure
        }
    }
    
    func testDismissSaveStatus() {
        let store = TestStore(
            initialState: AddHolidayModalState(saveStatus: .success),
            reducer: addHolidayModalReducer,
            environment: AddHolidayModalEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.dismissSaveStatus) {
            $0.saveStatus = nil
        }
    }
}
