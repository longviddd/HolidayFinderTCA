//
//  MyVacationsTests.swift
//  HolidayFinderTCATests
//
//  Created by long on 2024-03-31.
//

import XCTest
import ComposableArchitecture

@testable import HolidayFinderTCA

class MyVacationsTests: XCTestCase {
    let mockVacationDetails = VacationDetails(
        id: UUID(),
        originAirport: "JFK",
        destinationAirport: "LAX",
        startDate: Date(),
        endDate: Date()
    )
    override func setUp() {
        super.setUp()
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "vacationList")
    }
    
    func testOnAppear() {
        let store = TestStore(
            initialState: MyVacationsState(),
            reducer: myVacationsReducer,
            environment: MyVacationsEnvironment(
                mainQueue: .immediate
            )
        )
        
        store.send(.onAppear) {
            $0.isLoading = true
        }
        store.receive(.loadVacationsResponse(.success([]))) {
            $0.vacations = []
            $0.isLoading = false
        }
    }
    
    func testLoadVacations() {
        // Save a mock vacation to UserDefaults
        let encoder = JSONEncoder()
        if let encodedVacationDetails = try? encoder.encode([mockVacationDetails]) {
            UserDefaults.standard.set(encodedVacationDetails, forKey: "vacationList")
        }
        
        let store = TestStore(
            initialState: MyVacationsState(),
            reducer: myVacationsReducer,
            environment: MyVacationsEnvironment(
                mainQueue: .immediate
            )
        )
        
        store.send(.onAppear) {
            $0.isLoading = true
        }
        store.receive(.loadVacationsResponse(.success([mockVacationDetails]))) {
            $0.vacations = IdentifiedArray(uniqueElements: [self.mockVacationDetails])
            $0.isLoading = false
        }
    }
    
    func testDeleteVacation() {
        // Save a mock vacation to UserDefaults
        let encoder = JSONEncoder()
        if let encodedVacationDetails = try? encoder.encode([mockVacationDetails]) {
            UserDefaults.standard.set(encodedVacationDetails, forKey: "vacationList")
        }
        
        let store = TestStore(
            initialState: MyVacationsState(vacations: IdentifiedArray(uniqueElements: [mockVacationDetails])),
            reducer: myVacationsReducer,
            environment: MyVacationsEnvironment(
                mainQueue: .immediate
            )
        )
        
        store.send(.deleteVacation(id: mockVacationDetails.id)) {
            $0.vacations.remove(id: self.mockVacationDetails.id)
        }
        
        // Assert that the vacation is removed from UserDefaults
        let savedVacationsData = UserDefaults.standard.data(forKey: "vacationList")
        XCTAssertNotNil(savedVacationsData)
        
        if let data = savedVacationsData,
           let savedVacations = try? JSONDecoder().decode([VacationDetails].self, from: data) {
            XCTAssertEqual(savedVacations.count, 0)
        } else {
            XCTFail("Failed to decode saved vacations from UserDefaults")
        }
    }
    
    func testNavigateToFlightSearch() {
        let store = TestStore(
            initialState: MyVacationsState(),
            reducer: myVacationsReducer,
            environment: MyVacationsEnvironment(
                mainQueue: .immediate
            )
        )
        
        store.send(.navigateToFlightSearch(vacation: mockVacationDetails))
    }
}

