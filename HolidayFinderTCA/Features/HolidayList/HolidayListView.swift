//
//  HolidayListView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct HolidayListView: View {
    let store: Store<HolidayListState, HolidayListAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            List(viewStore.holidays, id: \.date) { holiday in
                NavigationLink(
                    destination: HolidayDetailView(
                        store: Store(
                            initialState: HolidayDetailState(holiday: holiday),
                            reducer: holidayDetailReducer,
                            environment: HolidayDetailEnvironment()
                        )
                    )
                ) {
                    VStack(alignment: .leading) {
                        Text(holiday.date)
                            .font(.headline)
                        Text(holiday.name)
                            .font(.subheadline)
                        Text(holiday.types.joined(separator: ", "))
                            .font(.caption)
                    }
                }
            }
            .navigationBarTitle("Holidays", displayMode: .inline)
        }
    }
}
