//
//  HolidaySearchState.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
import ComposableArchitecture

struct HolidaySearchState: Equatable {
    var testimonials = [
        "Finally, a travel app that gets me. Simple to use and always finds the best deals!",
        "Planning my holidays has never been easier. This app is a game-changer for travelers.",
        "Incredible app! Intuitive design and helpful features that made my vacation planning a breeze.",
        "Every feature you need to discover and book your perfect holiday is right here. Love it!",
        "I was impressed with how this app simplified the complex task of holiday planning. Highly recommend!",
        "A traveler's best friend! It's like having a personal travel agent in your pocket.",
        "The user experience is unmatched. Makes vacation search not just easy, but also fun.",
    ]
    var shouldNavigate = false
    var testimonialIndex = 0
    var nearestAirport: Airport?
    var vacationLocation: String = ""
    var upcomingCurrentYearOnly = false
    var yearSearch = String(Calendar.current.component(.year, from: Date()))
    var vacationLocationsJson: [Country] = []
    var isYearValid = true
    var needsAirportSelection = false
}
