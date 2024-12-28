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
    
    var body: some View {
        NavigationView {
            VStack {
                switch currentStep {
                case 1:
                    WelcomeView(currentStep: $currentStep)
                case 2:
                    AppDetectionView(currentStep: $currentStep)
                case 3:
                    SafariExtensionGuideView(currentStep: $currentStep)
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
        .onAppear {
            checkInitialState()
        }
    }
    
    private func checkInitialState() {
        // Check for conflicting apps
        let detector = AppDetector()
        if detector.hasConflictingApps() {
            currentStep = 2
            appState.resetSetup()
            return
        }
        
        // Check Safari extension status
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: "io.banish.app.ContentBlockerExtension") { state, error in
            DispatchQueue.main.async {
                if let isEnabled = state?.isEnabled, !isEnabled {
                    currentStep = 3
                    appState.resetSetup()
                }
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
