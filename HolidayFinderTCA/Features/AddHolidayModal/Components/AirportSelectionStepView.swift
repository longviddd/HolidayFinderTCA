//
//  AirportSelectionStepView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import SwiftUI
import ComposableArchitecture

struct AirportSelectionStepView: View {
    let store: Store<AddHolidayModalState, AddHolidayModalAction>
    let isOrigin: Bool
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(isOrigin ? "Origin Airport" : "Destination Airport")
                        .font(.headline)
                    
                    Text(isOrigin ? viewStore.originAirport : viewStore.destinationAirport)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        viewStore.send(.showAirportSelection(isOrigin: isOrigin))
                    }) {
                        Text("Select Airport")
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}
