// HolidaySearchTests.swift
import XCTest
import ComposableArchitecture

@testable import HolidayFinderTCA

class HolidaySearchTests: XCTestCase {
    let mockCountries = [
        Country(name: "United States", countryCode: "US"),
        Country(name: "United Kingdom", countryCode: "GB")
    ]
    func testHolidaySearchOnAppear() {
        let store = TestStore(
            initialState: HolidaySearchState(),
            reducer: holidaySearchReducer,
            environment: HolidaySearchEnvironment(
                networkService: .mocking(
                    fetchAvailableCountries: { Effect(value: self.mockCountries) }
                ),
                mainQueue: .immediate
            )
        )
        
        store.send(.onAppear)
        store.receive(.searchVacationLocations)
        store.receive(.searchVacationLocationsResponse(.success(mockCountries))) {
            $0.vacationLocationsJson = self.mockCountries
            $0.vacationLocation = self.mockCountries.first?.countryCode ?? ""
        }
    }
    
    func testSearchVacationLocationsFailure() {
        let store = TestStore(
            initialState: HolidaySearchState(),
            reducer: holidaySearchReducer,
            environment: HolidaySearchEnvironment(
                networkService: .mocking(
                    fetchAvailableCountries: { Effect(error: HolidaySearchError.fetchFailed) }
                ),
                mainQueue: .immediate
            )
        )
        
        store.send(.onAppear)
        store.receive(.searchVacationLocations)
        store.receive(.searchVacationLocationsResponse(.failure(HolidaySearchError.fetchFailed)))
    }
    
    func testValidateYear() {
        let store = TestStore(
            initialState: HolidaySearchState(yearSearch: "2020", isYearValid: false),
            reducer: holidaySearchReducer,
            environment: HolidaySearchEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.validateYear("2025")) {
            $0.yearSearch = "2025"
            $0.isYearValid = true
        }
    }
    
    func testUpdateYearSearch() {
        let store = TestStore(
            initialState: HolidaySearchState(),
            reducer: holidaySearchReducer,
            environment: HolidaySearchEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.updateYearSearch("2025")) {
            $0.yearSearch = "2025"
        }
        store.receive(.validateYear("2025"))
    }
    
    func testUpdateUpcomingCurrentYearOnly() {
        let store = TestStore(
            initialState: HolidaySearchState(),
            reducer: holidaySearchReducer,
            environment: HolidaySearchEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.updateUpcomingCurrentYearOnly(true)) {
            $0.upcomingCurrentYearOnly = true
            $0.yearSearch = "2024"
        }
        store.receive(.validateYear("2024"))
        
        store.send(.updateUpcomingCurrentYearOnly(false)) {
            $0.upcomingCurrentYearOnly = false
        }
    }
    
    func testSubmitSearch() {
        let mockHolidays = [
            Holiday(date: "2024-12-25", localName: "Christmas Day", name: "Christmas Day", countryCode: "US", fixed: true, global: true, counties: nil, launchYear: nil, types: ["Public"]),
            Holiday(date: "2024-01-01", localName: "New Year's Day", name: "New Year's Day", countryCode: "US", fixed: true, global: true, counties: nil, launchYear: nil, types: ["Public"])
        ]
        
        let store = TestStore(
            initialState: HolidaySearchState(vacationLocation: "US", yearSearch: "2024", isYearValid: true),
            reducer: holidaySearchReducer,
            environment: HolidaySearchEnvironment(
                networkService: .mocking(
                    fetchHolidays: { _, _, _ in Effect(value: mockHolidays) }
                ),
                mainQueue: .immediate
            )
        )
        
        store.send(.submitSearch) {
            $0.isSearching = true
        }
        
        let holidayListState = HolidayListState(holidays: mockHolidays)
        store.receive(.holidayList([holidayListState])) {
            $0.holidayList = [holidayListState]
            $0.isNavigatingToHolidayList = true
        }
    }
    
    func testUpdateVacationLocation() {
        let store = TestStore(
            initialState: HolidaySearchState(),
            reducer: holidaySearchReducer,
            environment: HolidaySearchEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.updateVacationLocation("GB")) {
            $0.vacationLocation = "GB"
        }
    }
    
    func testResetNavigationState() {
        let store = TestStore(
            initialState: HolidaySearchState(isNavigatingToHolidayList: true),
            reducer: holidaySearchReducer,
            environment: HolidaySearchEnvironment(
                networkService: .failing,
                mainQueue: .immediate
            )
        )
        
        store.send(.resetNavigationState) {
            $0.isNavigatingToHolidayList = false
        }
    }
}
