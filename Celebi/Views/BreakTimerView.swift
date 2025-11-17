//
//  BreakTimerView.swift
//  Celebi
//
//  Created by Fadhil Saheer on 17/11/25.
//


import SwiftUI

struct BreakTimerView: View {
    @EnvironmentObject var tracker: UsageTracker
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.95)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "figure.walk")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Time for a Break!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Please rest for:")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text(formatBreakTime(tracker.breakTimeRemaining))
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(.green)
                
                Button {
                    tracker.skipBreak()
                } label: {
                    Text("Skip Break")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
            }
            .padding(40)
        }
        .frame(width: 400, height: 250)
    }
    
    private func formatBreakTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}
