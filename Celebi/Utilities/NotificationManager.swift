//
//  NotificationManager.swift
//  Celebi
//
//  Created by Fadhil Saheer on 17/11/25.
//


import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    
    func sendBreakNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time for a Break! 🧘"
        content.body = "You've been working for 1 hour."
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}
