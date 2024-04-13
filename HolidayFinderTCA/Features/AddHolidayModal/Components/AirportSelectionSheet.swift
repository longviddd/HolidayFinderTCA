//
//  AirportSelectionSheet.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct AirportSelectionSheet: View {
    let store: Store<AddHolidayModalState, AddHolidayModalAction>
    let isOrigin: Bool
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    SearchBar(text: viewStore.binding(
                        get: \.searchQuery,
                        send: AddHolidayModalAction.searchAirports
                    ))
                    
                    List(viewStore.filteredAirports) { airport in
                        Button(action: {
                            viewStore.send(.selectAirport(airport, isOrigin: isOrigin))
                            viewStore.send(.hideAirportSelection)
                        }) {
                            Text("\(airport.name!) (\(airport.iata!))")
                        }
                    }
                }
                .navigationBarTitle("Select Airport", displayMode: .inline)
                .navigationBarItems(trailing: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
}
