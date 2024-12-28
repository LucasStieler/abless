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
        .preferredColorScheme(.light) // Force light mode
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

struct WelcomeView: View {
    @Binding var currentStep: Int
    
    var body: some View {
        VStack(spacing: 24) {
            // Animated gradient icon
            Image(systemName: "shield.slash.fill")
                .font(.system(size: 70))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(.bottom, 8)
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
            
            Text("Welcome to Banish")
                .font(.title)
                .bold()
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primary, .primary.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text("This app helps you block distracting short videos like YouTube Shorts, Instagram Reels, and TikTok videos.")
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)
            
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    currentStep += 1
                }
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
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
