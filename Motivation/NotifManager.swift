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
}
