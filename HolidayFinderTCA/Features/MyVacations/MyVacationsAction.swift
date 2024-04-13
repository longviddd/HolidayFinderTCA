//
//  MyVacationsAction.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//


import Foundation
import ComposableArchitecture

enum MyVacationsAction : Equatable {
    case onAppear
    case loadVacationsResponse(Result<[VacationDetails], Never>)
    case deleteVacation(id: VacationDetails.ID)
    case navigateToFlightSearch(vacation: VacationDetails)
}
