//
//  HolidayListReducer.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
// HolidayListReducer.swift
import ComposableArchitecture

let holidayListReducer = Reducer<HolidayListState, HolidayListAction, HolidayListEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        UserDefaults.standard.removeObject(forKey: "selectedAirport")
        print("print")
        return .none
    case .holidayDetail:
        return .none
        
    }
}
