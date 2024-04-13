//
//  ShowMoreButton.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

import Foundation
import SwiftUI

struct ShowMoreButton: View {
    let action: () -> Void
    var body: some View {
        Button("Show More") {
            action()
        }
        .padding()
    }
}
