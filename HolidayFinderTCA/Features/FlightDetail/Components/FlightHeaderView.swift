//
//  FlightHeaderView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

import Foundation
import SwiftUI
struct FlightHeaderView: View {
    let routeTitle: String
    let validatingCarrier: String
    let totalPrice: String
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(routeTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
            if !validatingCarrier.isEmpty {
                HStack {
                    Image(systemName: "airplane")
                    Text("Validating Carrier: \(validatingCarrier)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            
            HStack {
                Image(systemName: "tag")
                Text("Total Price: EUR \(totalPrice)")
                    .font(.title)
                    .foregroundColor(.green)
                    .fontWeight(.bold)
            }
        }
        .padding()
        
        HStack(spacing: 5) {
            Image(systemName: "info.circle")
                .foregroundColor(.gray)
            Text("Real price might be different from the flight lists. Please contact the validating carrier to purchase this offer.")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}
