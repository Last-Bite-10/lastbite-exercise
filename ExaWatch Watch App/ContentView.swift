//
//  ContentView.swift
//  ExaWatch Watch App
//
//  Created by Ammar Alifian Fahdan on 27/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var healthManager = WatchHealthManager()
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.fill")
                .imageScale(.large)
                .foregroundStyle(.red)
            
            Text("\(Int(healthManager.heartRate))")
                .font(.system(size: 60, weight: .bold, design: .rounded))
            
            Text("BPM")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .onAppear {
            healthManager.requestAuthorization()
            healthManager.startStreaming()
        }
        .onDisappear {
            healthManager.stopStreaming()
        }
    }
}

#Preview {
    ContentView()
}
