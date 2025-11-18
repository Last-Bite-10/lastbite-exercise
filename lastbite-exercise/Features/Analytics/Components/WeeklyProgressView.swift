//
//  WeeklyProgress.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 23/10/25.
//

import SwiftUI

struct WeeklyProgressView: View {
    var currentMinutes: Int
    var totalMinutes: Int
    
    var startDate: Date = Calendar.current.date(byAdding: .day, value: -4, to: Date())!
    var endDate: Date = Calendar.current.date(byAdding: .day, value: 3, to: Date())!

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Weekly Progress")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.blueTwo)
            
            Text("\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 20) {
                ZStack {
                    Image("WeeklyProgress")
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: 120, height: 120)

                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(currentMinutes)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color.blueTwo)
                        
                    Text("/\(totalMinutes) min")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color.blueTwo)
                }
                .frame(maxWidth: .infinity)
                
            }
            .padding()
            .background(Color("CardGray"))
            .cornerRadius(20)
        }
    }
}

#Preview {
    WeeklyProgressView(currentMinutes: 30, totalMinutes: 60)
}
