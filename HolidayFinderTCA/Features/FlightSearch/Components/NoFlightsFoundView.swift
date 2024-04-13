//
//  NoFlightsFoundView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

import Foundation
import SwiftUI

struct NoFlightsFoundView: View {
    let retryAction: () -> Void
    var body: some View {
        VStack {
            Text("No flights found. Try changing the airports or try again.")
            Button("Try Again") {
                retryAction()
            }
        }
    }
}
