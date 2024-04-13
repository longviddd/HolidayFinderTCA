//
//  SaveFlightButton.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

import Foundation
import SwiftUI
struct SaveFlightButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("Add to My Flight List")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding()
    }
}
