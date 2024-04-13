//
//  AddHolidayModalReducer.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
import ComposableArchitecture

let addHolidayModalReducer = Reducer<AddHolidayModalState, AddHolidayModalAction, AddHolidayModalEnvironment> { state, action, environment in
    switch action {
    case let .onAppear(initialStartDate):
        state.isLoading = true
        state.startDate = initialStartDate
        state.endDate = Calendar.current.date(byAdding: .day, value: 1, to: initialStartDate) ?? initialStartDate
        return environment.networkService.fetchAirports()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AddHolidayModalAction.fetchAirportsResponse)
    case let .fetchAirportsResponse(.success(airports)):
        state.isLoading = false
        state.airports = IdentifiedArrayOf(uniqueElements: airports)
        state.filteredAirports = state.airports
        return .none
        
    case .fetchAirportsResponse(.failure):
        state.isLoading = false
        return .none
        
    case let .searchAirports(query):
        state.searchQuery = query
        if query.isEmpty {
            state.filteredAirports = state.airports
        } else {
            state.filteredAirports = state.airports.filter { airport in
                (airport.name ?? "").localizedCaseInsensitiveContains(query) ||
                (airport.city ?? "").localizedCaseInsensitiveContains(query) ||
                (airport.country ?? "").localizedCaseInsensitiveContains(query) ||
                (airport.iata ?? "").localizedCaseInsensitiveContains(query)
            }
        }
        return .none
        
    case let .selectAirport(airport, isOrigin):
        if isOrigin {
            state.originAirport = airport.iata!
        } else {
            state.destinationAirport = airport.iata!
        }
        state.selectedAirport = airport
        return .none
        
    case let .showAirportSelection(isOrigin):
        state.searchQuery = ""
        state.filteredAirports = state.airports
        state.showAirportSelection = true
        state.selectedAirport = nil
        return .none
        
    case .hideAirportSelection:
        state.showAirportSelection = false
        return .none
        
    case let .setStartDate(date):
        state.startDate = date
        state.endDate = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
        return .none
        
    case let .setEndDate(date):
        state.endDate = date
        return .none
        
    case .nextStep:
        if state.currentStep < 4 {
            state.currentStep += 1
        }
        return .none
        
    case .previousStep:
        if state.currentStep > 1 {
            state.currentStep -= 1
        }
        return .none
        
    case .saveVacation:
        let vacationDetails = VacationDetails(id: UUID(), originAirport: state.originAirport, destinationAirport: state.destinationAirport, startDate: state.startDate, endDate: state.endDate)
        
        let encoder = JSONEncoder()
        if let encodedVacationDetails = try? encoder.encode(vacationDetails) {
            if var existingVacationsData = UserDefaults.standard.object(forKey: "vacationList") as? Data {
                var existingVacations = try? JSONDecoder().decode([VacationDetails].self, from: existingVacationsData)
                existingVacations?.append(vacationDetails)
                if let updatedVacationsData = try? encoder.encode(existingVacations) {
                    UserDefaults.standard.set(updatedVacationsData, forKey: "vacationList")
                    print("All saved vacations:")
                    print(existingVacations ?? [])
                    return Effect(value: .savingStatus(.success)).concatenate(with: Effect(value: .navigateToMyVacations))
                }
            } else {
                let firstVacationList = [vacationDetails]
                if let firstVacationData = try? encoder.encode(firstVacationList) {
                    UserDefaults.standard.set(firstVacationData, forKey: "vacationList")
                    print("All saved vacations:")
                    print(firstVacationList)
                    return Effect(value: .savingStatus(.success)).concatenate(with: Effect(value: .navigateToMyVacations))
                }
            }
        }
        return Effect(value: .savingStatus(.failure))
    case .navigateToMyVacations:
        return .none
        
    case let .savingStatus(status):
        state.saveStatus = status
        return .none
        
    case .dismissSaveStatus:
        state.saveStatus = nil
        return .none
    }
}
