//
//  RootReducer.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

// RootReducer.swift
import ComposableArchitecture

let rootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    holidaySearchReducer.pullback(
        state: \.holidaySearch,
        action: /RootAction.holidaySearch,
        environment: { $0.holidaySearchEnvironment }
    ),
    myVacationsReducer.pullback(
        state: \.myVacations,
        action: /RootAction.myVacations,
        environment: { $0.myVacationsEnvironment }
    ),
    myFlightsReducer.pullback(
        state: \.myFlights,
        action: /RootAction.myFlights,
        environment: { $0.myFlightsEnvironment }
    ),
    Reducer { state, action, _ in
        switch action {
        case .setActiveTab(let tab):
            state.activeTab = tab
            return .none
        case .navigate(let navigationState):
            state.navigationState = navigationState
            return .none
            
        case .holidaySearch, .myVacations, .myFlights:
            return .none
        }
    }
)

