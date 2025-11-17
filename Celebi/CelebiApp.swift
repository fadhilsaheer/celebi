//
//  CelebiApp.swift
//  Celebi
//
//  Created by Fadhil Saheer on 17/11/25.
//

import SwiftUI

@main
struct CelebiApp: App {
    @StateObject private var tracker = UsageTracker()
    
    var body: some Scene {
        MenuBarExtra("Celebi", systemImage: "clock.fill") {
            MenuView()
                .environmentObject(tracker)
        }
        .menuBarExtraStyle(.window)
    }
}
