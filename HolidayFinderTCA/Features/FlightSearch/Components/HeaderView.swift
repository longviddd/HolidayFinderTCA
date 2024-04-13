//
//  HeaderView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    let vacation: VacationDetails
    var body: some View {
        Text("All flights from \(vacation.originAirport) to \(vacation.destinationAirport)")
            .font(.title)
            .padding(.bottom)
    }
}
