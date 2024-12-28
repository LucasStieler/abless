//
//  BanishApp.swift
//  Banish
//
//  Created by Lucas Maximilian Stieler on 22.12.24.
//

import SwiftUI
import UserNotifications
import BackgroundTasks

@main
struct BanishApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // Force portrait orientation
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    var body: some Scene {
        WindowGroup {
            LoadingView()
                .preferredColorScheme(.light) // Force light mode
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Request notification permissions right away
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
        
        // Register background task
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "io.banish.app.refresh",
            using: nil
        ) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        // Schedule initial background task
        scheduleAppRefresh()
        
        // Also check for apps immediately
        checkForConflictingApps()
        
        return true
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "io.banish.app.refresh")
        // Set to minimum allowed interval for more frequent checks
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60) // Check every minute if possible
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Background refresh scheduled for next minute")
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        // Create a task to ensure it completes
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        // Check for apps
        checkForConflictingApps()
        
        // Schedule next refresh
        scheduleAppRefresh()
        
        // Mark task complete
        task.setTaskCompleted(success: true)
    }
    
    private func checkForConflictingApps() {
        let detector = AppDetector()
        if detector.hasConflictingApps() {
            // Create and configure notification
            let content = UNMutableNotificationContent()
            content.title = "Action Required"
            content.body = "YouTube or other conflicting apps have been detected. Please open Banish to maintain your distraction-free browsing."
            content.sound = .default
            
            // Create request with immediate trigger
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: nil
            )
            
            // Schedule notification
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Notification scheduled successfully")
                }
            }
        }
    }
    
    // Handle notification when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
    
    // Handle notification tap
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        UserDefaults.standard.set(false, forKey: "setupCompleted")
        completionHandler()
    }
} 