//
//  FlightRowContent.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

import Foundation
import SwiftUI

struct FlightRowContent: View {
    let flight: Flight
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Outbound")
                        .font(.headline)
                    Text("\(flight.outboundOriginAirport) -> \(flight.outboundDestinationAirport)")
                    Text("Duration: \(flight.outboundDuration)")
                }
                Spacer()
                
                Text("\(flight.price, specifier: "%.2f") EUR")
                    .font(.title2)
                    .foregroundColor(.green)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Return")
                        .font(.headline)
                    Text("\(flight.returnOriginAirport) -> \(flight.returnDestinationAirport)")
                    Text("Duration: \(flight.returnDuration)")
                }
                
                Spacer()
            }
            
            Divider()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}
