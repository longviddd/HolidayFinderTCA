//
//  MyVacationsReducer.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
import ComposableArchitecture

let myVacationsReducer = Reducer<MyVacationsState, MyVacationsAction, MyVacationsEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        state.isLoading = true
        return Effect(value: .loadVacationsResponse(.success(loadVacationsFromUserDefaults())))
        
    case let .loadVacationsResponse(.success(vacations)):
        state.vacations = IdentifiedArray(uniqueElements: vacations)
        print("Run")
        print(state.vacations)
        state.isLoading = false
        return .none
        
    case .loadVacationsResponse(.failure):
        state.isLoading = false
        return .none
        
    case let .deleteVacation(id):
        state.vacations.remove(id: id)
        saveVacationsToUserDefaults(state.vacations.elements)
        return .none
        
     case .navigateToFlightSearch:
         return .none
    }
}

private func loadVacationsFromUserDefaults() -> [VacationDetails] {
    if let data = UserDefaults.standard.data(forKey: "vacationList"),
       let vacationList = try? JSONDecoder().decode([VacationDetails].self, from: data) {
        return vacationList
    }
    return []
}

private func saveVacationsToUserDefaults(_ vacations: [VacationDetails]) {
    if let encodedData = try? JSONEncoder().encode(vacations) {
        UserDefaults.standard.set(encodedData, forKey: "vacationList")
    }
}
