// HolidayListTests.swift
import XCTest
import ComposableArchitecture

@testable import HolidayFinderTCA

class HolidayListTests: XCTestCase {
    let mockHolidays = [
        Holiday(date: "2024-12-25", localName: "Christmas Day", name: "Christmas Day", countryCode: "US", fixed: true, global: true, counties: nil, launchYear: nil, types: ["Public"]),
        Holiday(date: "2024-01-01", localName: "New Year's Day", name: "New Year's Day", countryCode: "US", fixed: true, global: true, counties: nil, launchYear: nil, types: ["Public"])
    ]
    
    func testHolidayListOnAppear() {
        let store = TestStore(
            initialState: HolidayListState(holidays: mockHolidays),
            reducer: holidayListReducer,
            environment: HolidayListEnvironment()
        )
        
        store.send(.onAppear)
    }
    
    func testHolidayDetail() {
        let store = TestStore(
            initialState: HolidayListState(holidays: mockHolidays),
            reducer: holidayListReducer,
            environment: HolidayListEnvironment()
        )
        
        store.send(.holidayDetail(HolidayDetailState(holiday: mockHolidays[0])))
    }
}
