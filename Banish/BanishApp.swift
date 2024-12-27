//
//  BanishApp.swift
//  Banish
//
//  Created by Lucas Maximilian Stieler on 22.12.24.
//

import SwiftUI
import UserNotifications

@main
struct BanishApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Request notification permissions
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
                // Register for remote notifications after permission is granted
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
        return true
    }
    
    // Handle successful registration of remote notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        // Send this token to your server
    }
    
    // Handle registration errors
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    // Handle silent push notification
    func application(_ application: UIApplication,
                    didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Check if this is a background refresh
        guard application.applicationState == .background else {
            completionHandler(.noData)
            return
        }
        
        // Check for conflicting apps
        let detector = AppDetector()
        if detector.hasConflictingApps() {
            // Send user notification
            let content = UNMutableNotificationContent()
            content.title = "Conflicting App Detected"
            content.body = "YouTube or other conflicting apps have been installed. Please open Banish to maintain your distraction-free browsing."
            content.sound = .default
            
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                              content: content,
                                              trigger: nil)
            
            UNUserNotificationCenter.current().add(request)
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
    }
    
    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        // Reset setup state when notification is tapped
        UserDefaults.standard.set(false, forKey: "setupCompleted")
        completionHandler()
    }
} 