//
//  TimeDisplayView.swift
//  Celebi
//
//  Created by Fadhil Saheer on 17/11/25.
//


import SwiftUI

struct TimeDisplayView: View {
    let seconds: TimeInterval
    
    var body: some View {
        Text(formatTime(seconds))
            .font(.title2.monospacedDigit())
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}
