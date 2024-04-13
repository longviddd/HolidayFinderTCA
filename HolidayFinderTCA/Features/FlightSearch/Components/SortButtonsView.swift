//
//  SortButtonsView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

import Foundation
import SwiftUI
struct SortButtonsView: View {
    let sortByDuration: () -> Void
    let sortByPrice: () -> Void
    var body: some View {
        HStack {
            Button(action: sortByDuration) {
                Text("Sort by Duration")
                    .foregroundColor(.blue)
            }
            Spacer()
            
            Button(action: sortByPrice) {
                Text("Sort by Price")
                    .foregroundColor(.blue)
            }
        }
        .padding(.bottom)
    }
}
