//
//  ContentView.swift
//  Banish
//
//  Created by Lucas Maximilian Stieler on 22.12.24.
//

import SwiftUI
import SafariServices

struct ContentView: View {
    @StateObject private var appState = AppState()
    @State private var currentStep = 1
    @State private var hasConflictingApps = false
    @State private var extensionEnabled = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                switch currentStep {
                case 1:
                    WelcomeView(currentStep: $currentStep)
                case 2:
                    AppDetectionView(currentStep: $currentStep)
                        .onAppear {
                            checkForConflictingApps()
                        }
                case 3:
                    SafariExtensionGuideView(currentStep: $currentStep)
                        .onAppear {
                            checkExtensionStatus()
                        }
                case 4:
                    SafariLoginView(currentStep: $currentStep)
                case 5:
                    SuccessView()
                        .onAppear {
                            appState.completeSetup()
                        }
                default:
                    WelcomeView(currentStep: $currentStep)
                }
            }
        }
        .preferredColorScheme(.light)
    }
    
    private func checkSetupStatus() {
        // Check for conflicting apps
        let detector = AppDetector()
        if detector.hasConflictingApps() {
            currentStep = 2  // Return to app detection step
            appState.resetSetup()
            return
        }
        
        // Check Safari extension status
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: "io.banish.app.ContentBlockerExtension") { state, error in
            DispatchQueue.main.async {
                print("Checking extension status...")
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                if let isEnabled = state?.isEnabled {
                    print("Extension enabled: \(isEnabled)")
                    if !isEnabled {
                        currentStep = 3
                        appState.resetSetup()
                    }
                }
            }
        }
    }
    
    private func checkForConflictingApps() {
        let detector = AppDetector()
        hasConflictingApps = detector.hasConflictingApps()
    }
    
    private func checkExtensionStatus() {
        print("Checking extension status...")
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: "io.banish.app.ContentBlockerExtension") { state, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Extension error: \(error.localizedDescription)")
                    showError = true
                    errorMessage = error.localizedDescription
                    return
                }
                
                extensionEnabled = state?.isEnabled ?? false
                print("Extension enabled: \(extensionEnabled)")
            }
        }
    }
    
    func runDiagnostics() {
        print("=== Banish Diagnostics ===")
        print("Bundle ID: \(Bundle.main.bundleIdentifier ?? "unknown")")
        print("Extension enabled: \(extensionEnabled)")
        print("Current step: \(currentStep)")
        print("Has conflicting apps: \(hasConflictingApps)")
        print("Setup completed: \(appState.setupCompleted)")
        
        // Check extension
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: "io.banish.app.ContentBlockerExtension") { state, error in
            print("Extension state: \(String(describing: state?.isEnabled))")
            if let error = error {
                print("Extension error: \(error)")
            }
        }
    }
}

func reloadContentBlocker() {
    SFContentBlockerManager.reloadContentBlocker(
        withIdentifier: "io.banish.app.ContentBlockerExtension") { error in
        if let error = error {
            print("Error reloading content blocker: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
