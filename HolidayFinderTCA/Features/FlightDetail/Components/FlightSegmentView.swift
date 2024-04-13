//
//  FlightSegmentView.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-31.
//

import Foundation
import SwiftUI
struct FlightSegmentView: View {
    let segment: Segment
    let isReturn: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: isReturn ? "airplane.arrival" : "airplane.departure")
                Text("\(segment.departure.iataCode) to \(segment.arrival.iataCode)")
                    .font(.headline)
            }
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Image(systemName: "calendar")
                    Text(formatDate(segment.departure.at))
                        .font(.subheadline)
                }
                
                HStack {
                    Image(systemName: "clock")
                    Text("\(formatTime(segment.departure.at)) - \(formatTime(segment.arrival.at))")
                        .font(.subheadline)
                }
                
                HStack {
                    Image(systemName: "info.circle")
                    Text("\(segment.carrierCode) · \(segment.aircraft.code) · \(formatDuration(segment.duration ?? ""))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                if segment.co2Emissions != nil {
                    HStack {
                        Image(systemName: "leaf")
                        Text("CO2 Emissions: \(String(segment.co2Emissions![0].weight)) kg")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.vertical, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func formatTime(_ timeString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: timeString) else {
            return ""
        }
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    private func formatDuration(_ duration: String) -> String {
        return duration.replacingOccurrences(of: "PT", with: "")
    }
}

