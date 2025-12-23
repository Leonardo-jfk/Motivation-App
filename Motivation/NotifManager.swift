//
//  NotifManager.swift
//  Motivation
//
//  Created by Leonardo Aurelio on 18/12/2025.
//
import UserNotifications
import SwiftUI

class NotificationManager {
    
    static let shared = NotificationManager()
    
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])  { granted, error in
            if granted {
                print("notif granted")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            else{
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
        
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
            
        )
        let identifier = "daily-\(hour)-\(minute)"
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily notification: \(error)")
            }
            else {
                print("Daily notification scheduled for \(hour):\(minute)")
            }
        }
        
        
    }
    
    
    
    //if i will need fast locan notifications
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
    
    func chooseNotifTime(hour: Int) {
        @Published var notifEnabled: Bool =  UserDefaults.standard.bool(forKey: "notifEnabled")
         {
             didSet {
                 // Persist to UserDefaults so @AppStorage in SettingsList stays in sync
                 UserDefaults.standard.set(nofitEnabled, forKey: "notifEnabled")

                 // Apply immediately
                 if notifEnabled {
                     startBackgroundMusicIfNeeded()
                 } else {
                     stopBackgroundMusic()
                 }
             }
         }
    }
    
    
}
    //USAGE:
//sheduleDailyNotification(
//    hour:10
//    minute: 10
//    title: "Your wisdom"
//    body: "Marco Aurelio"
    

