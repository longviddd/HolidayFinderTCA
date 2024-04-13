//
//  YearPickerView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-04-10.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct YearPickerView: View {
    @Binding var selectedYear: String
    var isDisabled: Bool
    
    var body: some View {
        Menu {
            ForEach(currentYear...2073, id: \.self) { year in
                Button(action: {
                    selectedYear = String(year)
                }) {
                    Text(String(year))
                }
            }
        } label: {
            HStack {
                Text("Choose Year")
                Spacer()
                Text(selectedYear)
            }
            .foregroundColor(isDisabled ? .gray : .blue)
        }
        .disabled(isDisabled)
    }
    
    private var currentYear: Int {
        return Calendar.current.component(.year, from: Date())
    }
}
