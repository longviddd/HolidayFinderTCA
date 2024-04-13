//
//  AddHolidayModalState.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

// AddHolidayModalState.swift
import Foundation
import ComposableArchitecture

struct AddHolidayModalState: Equatable {
    var originAirport: String = ""
    var destinationAirport: String = ""
    var startDate = Date()
    var endDate = Date()
    var currentStep = 1
    var isLoading = false
    var showAirportSelection: Bool = false
    var airports: IdentifiedArrayOf<Airport> = []
    var filteredAirports: IdentifiedArrayOf<Airport> = []
    var searchQuery: String = ""
    var selectedAirport: Airport?
    var saveStatus : SaveStatus?
}
