//
//  BanishApp.swift
//  Banish
//
//  Created by Lucas Maximilian Stieler on 22.12.24.
//

import SwiftUI
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
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
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
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        checkForConflictingApps()
        scheduleAppRefresh()
        task.setTaskCompleted(success: true)
    }
    
    private func checkForConflictingApps() {
        let detector = AppDetector()
        if detector.hasConflictingApps() {
            UserDefaults.standard.set(false, forKey: "setupCompleted")
        }
    }
} 