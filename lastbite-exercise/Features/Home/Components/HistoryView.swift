//
//  HistoryView.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 23/10/25.
//

import SwiftUI

struct HistoryItem: Identifiable {
    let id = UUID()
    let minutes: Int
    let totalMinutes: Int
    let date: Date
}

struct RecentHistoryView: View {
    let historyItems: [HistoryItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent History")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
            
            VStack(spacing: 12) {
                ForEach(historyItems) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(item.minutes)/\(item.totalMinutes) mins")
                            .font(.headline)
                        
                        Text(item.date, format: .dateTime.weekday().day().month().year())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
        }
    }
}
