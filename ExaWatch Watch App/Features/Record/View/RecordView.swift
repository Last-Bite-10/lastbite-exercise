//
//  RecordView.swift
//  ExaWatch Watch App
//
//  Created by Ammar Alifian Fahdan on 27/10/25.
//

import SwiftUI

struct RecordView: View {
    @StateObject private var healthManager = WatchHealthManager()
    @StateObject private var viewModel = WatchRecordViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Heart Rate Display
//            VStack(spacing: 8) {
//                Image(systemName: "heart.fill")
//                    .imageScale(.large)
//                    .foregroundStyle(.red)
//                
//                Text("\(Int(healthManager.heartRate))")
//                    .font(.system(size: 48, weight: .bold, design: .rounded))
//                
//                Text("BPM")
//                    .font(.caption)
//                    .foregroundStyle(.secondary)
//            }
//            
            // Progress Circle
            ZStack {
                Circle()
                    .stroke(
                        !viewModel.isPaused
                        ? Color.accentColor.opacity(0.2)
                        : Color.gray.opacity(0.3),
                        lineWidth: 12
                    )

                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(
                        !viewModel.isPaused
                        ? Color.blue
                        : Color.gray,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: viewModel.progress)
                
                VStack(spacing: 4) {
                    Text("Active Time").font(.system(size: 10))
                    Text(viewModel.timeRemainingFormatted)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    
                    Text("BPM").font(.system(size: 10))
                    
                    Text("\(Int(healthManager.heartRate))")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    
//                    Text(viewModel.isPaused ? "Paused" : "Active")
//                        .font(.caption2)
//                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 120)
            .padding()
            
            VStack {
                Text("Total Time: **\(viewModel.timeTotalFormatted)** ").font(.system(size: 12))
            }
        }
        .onAppear {
            healthManager.requestAuthorization()
            healthManager.startStreaming()
            viewModel.connectToHealthManager(healthManager)
        }
        .onDisappear {
            healthManager.stopStreaming()
        }
    }
}

#Preview {
    RecordView()
}
