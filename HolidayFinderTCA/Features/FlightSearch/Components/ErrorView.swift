//
//  ErrorView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    let retryAction: () -> Void
    var body: some View {
        VStack {
            Text("An error occurred. Please try again.")
            Button("Try Again") {
                retryAction()
            }
        }
    }
}
