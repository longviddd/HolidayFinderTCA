//
//  HolidayDetailView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct HolidayDetailView: View {
    let store: Store<HolidayDetailState, HolidayDetailAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(viewStore.holiday.name)
                        .font(.largeTitle)
                    Text("\(viewStore.holiday.date) (\(getDayOfWeek(date: viewStore.holiday.date) ?? "N/A"))")
                        .font(.title2)
                    Text(viewStore.holiday.types[0])
                        .font(.title3)
                    Button("Add to My Vacation List") {
                        viewStore.send(.addToMyVacationList)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("Holiday Details", displayMode: .inline)
            .sheet(isPresented: viewStore.binding(
                get: \.showingAddHolidayModal,
                send: { _ in .dismissAddHolidayModal }
            )) {
                AddHolidayModalView(
                    store: Store(
                        initialState: AddHolidayModalState(
                            originAirport: viewStore.defaultOriginAirport,
                            startDate: viewStore.holiday.date.toDate() ?? Date()
                        ),
                        reducer: addHolidayModalReducer,
                        environment: AddHolidayModalEnvironment(
                            networkService: .live,
                            mainQueue: .main
                        )
                    ),
                    initialStartDate: viewStore.holiday.date.toDate() ?? Date() // Pass the initialStartDate here
                )
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
    
    private func getDayOfWeek(date: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: date) else { return nil }
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
