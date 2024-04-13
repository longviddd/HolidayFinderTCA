//
//  DateSelectionStepView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import SwiftUI
import ComposableArchitecture

struct DateSelectionStepView: View {
    let store: Store<AddHolidayModalState, AddHolidayModalAction>
    let isStartDate: Bool
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(isStartDate ? "Start Date" : "End Date")
                        .font(.headline)
                    
                    DatePicker(
                        "",
                        selection: isStartDate ? viewStore.binding(
                            get: \.startDate,
                            send: AddHolidayModalAction.setStartDate
                        ) : viewStore.binding(
                            get: \.endDate,
                            send: AddHolidayModalAction.setEndDate
                        ),
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(CompactDatePickerStyle())
                }
                
                Spacer()
            }
            .padding()
        }
    }
}
