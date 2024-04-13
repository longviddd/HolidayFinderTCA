//
//  AddHolidayModalAction.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//


import Foundation
import ComposableArchitecture
enum AddHolidayModalAction : Equatable {
    case onAppear(initialStartDate: Date)
    case fetchAirportsResponse(Result<[Airport], Never>)
    case searchAirports(query: String)
    case selectAirport(Airport, isOrigin: Bool)
    case showAirportSelection(isOrigin: Bool)
    case setStartDate(Date)
    case setEndDate(Date)
    case nextStep
    case previousStep
    case saveVacation
    case hideAirportSelection
    case savingStatus(SaveStatus)
    case dismissSaveStatus
    case navigateToMyVacations
}

