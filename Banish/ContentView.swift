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
    @State private var setupNeeded = false
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    LoadingView()
                } else {
                    VStack {
                        switch currentStep {
                        case 1:
                            if setupNeeded {
                                WelcomeView(currentStep: $currentStep)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)
                                    ))
                            } else {
                                HowItWorksView(currentStep: $currentStep)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)
                                    ))
                            }
                        case 2:
                            if setupNeeded {
                                AppDetectionView(currentStep: $currentStep)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)
                                    ))
                            } else {
                                SafariLoginView(currentStep: $currentStep, isSetupComplete: true)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)
                                    ))
                            }
                        case 3:
                            if setupNeeded {
                                SafariExtensionGuideView(currentStep: $currentStep)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)
                                    ))
                            }
                        case 4:
                            if setupNeeded {
                                SafariLoginView(currentStep: $currentStep, isSetupComplete: false)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)
                                    ))
                            }
                        case 5:
                            if setupNeeded {
                                SuccessView()
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)
                                    ))
                                    .onAppear {
                                        appState.completeSetup()
                                    }
                            }
                        default:
                            WelcomeView(currentStep: $currentStep)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                        }
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentStep)
                }
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            checkInitialState()
        }
    }
    
    private func checkInitialState() {
        print("\n--- Starting Initial State Check ---") // Debug print
        
        // First check for conflicting apps
        let detector = AppDetector()
        hasConflictingApps = detector.hasConflictingApps()
        print("Initial check - Conflicting apps detected: \(hasConflictingApps)") // Debug print
        
        // Then check Safari extension status
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: "io.banish.app.ContentBlockerExtension") { state, error in
            DispatchQueue.main.async {
                extensionEnabled = state?.isEnabled ?? false
                print("Initial check - Extension enabled: \(extensionEnabled)") // Debug print
                
                // Set setup needed if either condition is true
                setupNeeded = hasConflictingApps || !extensionEnabled
                print("Initial check - Setup needed: \(setupNeeded)") // Debug print
                
                // Always start at step 1 if setup is needed
                if setupNeeded {
                    print("Initial check - Resetting to setup flow") // Debug print
                    currentStep = 1
                    appState.resetSetup()
                }
                
                // Delay removing loading screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    print("Initial check - Removing loading screen. Final state:") // Debug print
                    print("  Setup needed: \(setupNeeded)") // Debug print
                    print("  Current step: \(currentStep)") // Debug print
                    print("  Has conflicting apps: \(hasConflictingApps)") // Debug print
                    print("  Extension enabled: \(extensionEnabled)") // Debug print
                    isLoading = false
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
