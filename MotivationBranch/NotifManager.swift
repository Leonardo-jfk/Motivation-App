//
//  NotifManager.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 18/12/2025.
//
import UserNotifications
import SwiftUI
import Combine

@MainActor
final class NotifManager: ObservableObject {
    
    static let shared = NotifManager()
    
    // Keys
    private let enabledKey = "notifEnabled"
    private let hourKey = "notifHour"
    private let minuteKey = "notifMinute"
    
    // Persisted user preference for notifications
    @Published var notifEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notifEnabled, forKey: enabledKey)
            if notifEnabled {
                // If no time saved yet, default to 9:00 and persist it once
                let hour = UserDefaults.standard.object(forKey: hourKey) as? Int ?? 9
                let minute = UserDefaults.standard.object(forKey: minuteKey) as? Int ?? 0
                UserDefaults.standard.set(hour, forKey: hourKey)
                UserDefaults.standard.set(minute, forKey: minuteKey)
                // Schedule at saved/default time
                scheduleFromStoredTime()
            } else {
                stopNotif()
            }
        }
    }
    
    private init() {
        self.notifEnabled = UserDefaults.standard.bool(forKey: enabledKey)
    }
    
    // Current stored time (defaults used if missing)
    var storedHour: Int {
        UserDefaults.standard.object(forKey: hourKey) as? Int ?? 9
    }
    var storedMinute: Int {
        UserDefaults.standard.object(forKey: minuteKey) as? Int ?? 0
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])  { granted, error in
            if granted {
                print("notif granted")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("notif denied")
            }
        }
    }
    
    func sheduleDailyNotification(hour: Int, minute: Int, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let identifier = "daily-\(hour)-\(minute)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily notification: \(error)")
            } else {
                print("Daily notification scheduled for \(hour):\(minute)")
            }
        }
    }
    
    // Quick local notification
    func sendLocalNotification(title: String, body: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, timeInterval), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling local notification: \(error)")
            } else {
                print("Local notification scheduled in \(timeInterval) seconds")
            }
        }
    }
    
    // Remove pending and delivered notifications
    func stopNotif() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        print("All pending and delivered notifications removed")
    }
    
    // Persist the chosen time and reschedule if enabled
    func setDailyTime(hour: Int, minute: Int) {
        UserDefaults.standard.set(hour, forKey: hourKey)
        UserDefaults.standard.set(minute, forKey: minuteKey)
        if notifEnabled {
            // Clear existing and reschedule at the new time
            stopNotif()
            scheduleFromStoredTime()
        }
    }
    func todaysQuoteText(for date: Date = .now) -> String {
      guard !quotesEng.isEmpty else { return "No quotes available." }

      let day = dayOfYear(for: date) // 1-based

      let index = (day - 1) % quotesEng.count

      return quotesEng[index]

    }

    private func scheduleFromStoredTime() {
        let hour = storedHour
        let minute = storedMinute
        sheduleDailyNotification(hour: hour, minute: minute, title: "Your wisdom", body: "\(todaysQuoteText())")
    }
}
