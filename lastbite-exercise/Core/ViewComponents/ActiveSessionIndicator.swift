//
//  ActiveSessionIndicator.swift
//  Exa
//
//  Created for showing active recording session indicator
//

import SwiftUI

struct ActiveSessionIndicator: View {
    @ObservedObject var sessionManager: RecordSessionManager
    @State private var isPulsing = false
    
    var body: some View {
        if sessionManager.hasActiveSession,
           let session = sessionManager.activeSession {
            VStack(spacing: 0) {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        sessionManager.navigateToActiveSession()
                    }) {
                        HStack(spacing: 8) {
//                            // Pulsing red dot
//                            Circle()
//                                .fill(Color.red)
//                                .frame(width: 8, height: 8)
//                                .scaleEffect(isPulsing ? 1.2 : 1.0)
//                                .animation(
//                                    Animation.easeInOut(duration: 0.8)
//                                        .repeatForever(autoreverses: true),
//                                    value: isPulsing
//                                )
//                            
//                            Text("Recording")
//                                .font(.caption)
//                                .fontWeight(.semibold)
//                            
//                            Text(formatTime(session.timer.totalTime))
//                                .font(.caption)
//                                .monospacedDigit()
                            
                            Image(systemName: "play.fill")                                .frame(width: 8, height: 8)
                                .scaleEffect(isPulsing ? 1.3 : 1.0)
                                .animation(
                                    Animation.easeInOut(duration: 1)
                                        .repeatForever(autoreverses: true),
                                    value: isPulsing
                                )
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                        .background(
                            Capsule()
                                .fill(Color.blueTwo.opacity(0.9))
                        )
                        .foregroundColor(.white)
                    }
                    .padding(.trailing, 16)
                }
                .padding(.bottom, 80)  // Position above tab bar
            }
            .onAppear {
                isPulsing = true
            }
        }
    }
    
    private func formatTime(_ duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

