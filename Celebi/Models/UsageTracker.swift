//
//  UsageTracker.swift
//  Celebi
//
//  Created by Fadhil Saheer on 17/11/25.
//


import Foundation
import IOKit
import UserNotifications
import Combine
import AppKit
import SwiftUI

class UsageTracker: ObservableObject {
    @Published var activeUsageSeconds: TimeInterval = 0
    @Published var isOnBreak = false
    @Published var breakTimeRemaining: TimeInterval = 300
    @Published var isEnabled = true
    
    private var checkTimer: Timer?
    private var breakTimer: Timer?
    private var breakWindow: NSWindow?
    
    private let activeThreshold: TimeInterval = 3600 // 1 hour
    private let breakDuration: TimeInterval = 300 // 5 minutes
    private let idleResetThreshold: TimeInterval = 300 // 5 minutes
    private let checkInterval: TimeInterval = 10 // Check every 10 seconds
    
    init() {
        requestNotificationPermission()
        startTracking()
    }
    
    func startTracking() {
        checkTimer = Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { [weak self] _ in
            self?.updateUsageTracking()
        }
    }
    
    private func updateUsageTracking() {
        guard isEnabled, !isOnBreak else { return }
        guard let idleTime = getSystemIdleTime() else { return }
        
        if idleTime >= idleResetThreshold {
            // Reset if idle for 5+ minutes
            activeUsageSeconds = 0
        } else {
            // Count as active usage (even if idle < 5 minutes)
            activeUsageSeconds += checkInterval
            
            if activeUsageSeconds >= activeThreshold {
                startBreak()
            }
        }
    }
    
    private func startBreak() {
        isOnBreak = true
        activeUsageSeconds = 0
        breakTimeRemaining = breakDuration
        
        sendBreakNotification()
        showBreakWindow()
        
        // Countdown timer
        breakTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.breakTimeRemaining > 0 {
                self.breakTimeRemaining -= 1
            } else {
                self.endBreak()
            }
        }
    }
    
    private func endBreak() {
        isOnBreak = false
        breakTimer?.invalidate()
        breakTimer = nil
        hideBreakWindow()
    }
    
    func skipBreak() {
        endBreak()
    }
    
    private func showBreakWindow() {
        let breakWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 250),
            styleMask: [.titled, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        breakWindow.level = .floating
        breakWindow.center()
        breakWindow.isMovableByWindowBackground = true
        breakWindow.titlebarAppearsTransparent = true
        breakWindow.contentView = NSHostingView(
            rootView: BreakTimerView()
                .environmentObject(self)
        )
        
        breakWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        self.breakWindow = breakWindow
    }
    
    private func hideBreakWindow() {
        breakWindow?.close()
        breakWindow = nil
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    
    private func sendBreakNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time for a Break! 🧘"
        content.body = "You've been working for 1 hour. Take a 5-minute break."
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // IOKit idle time detection
    private func getSystemIdleTime() -> Double? {
        var iterator: io_iterator_t = 0
        defer { IOObjectRelease(iterator) }
        
        guard IOServiceGetMatchingServices(kIOMainPortDefault, 
                                           IOServiceMatching("IOHIDSystem"), 
                                           &iterator) == KERN_SUCCESS else {
            return nil
        }
        
        let entry: io_registry_entry_t = IOIteratorNext(iterator)
        guard entry != 0 else { return nil }
        defer { IOObjectRelease(entry) }
        
        var unmanagedDict: Unmanaged<CFMutableDictionary>?
        guard IORegistryEntryCreateCFProperties(entry, 
                                               &unmanagedDict, 
                                               kCFAllocatorDefault, 
                                               0) == KERN_SUCCESS,
              let dict = unmanagedDict?.takeRetainedValue() else {
            return nil
        }
        
        let key = "HIDIdleTime" as CFString
        guard let value = CFDictionaryGetValue(dict, Unmanaged.passUnretained(key).toOpaque()) else {
            return nil
        }
        
        var nanoseconds: Int64 = 0
        let number = unsafeBitCast(value, to: CFNumber.self)
        guard CFNumberGetValue(number, CFNumberType.sInt64Type, &nanoseconds) else {
            return nil
        }
        
        return Double(nanoseconds) / Double(NSEC_PER_SEC)
    }
    
    deinit {
        checkTimer?.invalidate()
        breakTimer?.invalidate()
    }
}
