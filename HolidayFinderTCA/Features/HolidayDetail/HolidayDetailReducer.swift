//
//  HolidayDetailReducer.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
import ComposableArchitecture

let holidayDetailReducer = Reducer<HolidayDetailState, HolidayDetailAction, HolidayDetailEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        if let data = UserDefaults.standard.object(forKey: "selectedAirport") as? Data,
           let airport = try? JSONDecoder().decode(Airport.self, from: data) {
            state.defaultOriginAirport = airport.iata!
        }
        return .none
    case .addToMyVacationList:
        state.showingAddHolidayModal = true
        return .none
        
    case .dismissAddHolidayModal:
        state.showingAddHolidayModal = false
        return .none
    }
}
