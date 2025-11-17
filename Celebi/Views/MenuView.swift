//
//  MenuView.swift
//  Celebi
//
//  Created by Fadhil Saheer on 17/11/25.
//


import SwiftUI

struct MenuView: View {
    @EnvironmentObject var tracker: UsageTracker
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Celebi")
                .font(.headline)
            
            Divider()
            
            if tracker.isOnBreak {
                HStack {
                    Image(systemName: "cup.and.saucer.fill")
                    Text("On Break")
                        .foregroundColor(.green)
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Active Usage")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(formatTime(tracker.activeUsageSeconds))
                        .font(.title2)
                        .monospacedDigit()
                    
                    ProgressView(value: tracker.activeUsageSeconds / 3600)
                        .frame(width: 200)
                }
            }
            
            Divider()
            
            Toggle("Enable Tracking", isOn: $tracker.isEnabled)
            
            Button("Reset Counter") {
                tracker.activeUsageSeconds = 0
            }
            
            Divider()
            
            Button("Quit Celebi") {
                NSApp.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: .command)
        }
        .padding()
        .frame(width: 250)
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}
