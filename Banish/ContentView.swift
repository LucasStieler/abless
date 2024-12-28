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
    @State private var opacity: CGFloat = 0 // For fade transitions
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    LoadingView()
                        .transition(.opacity.combined(with: .scale(scale: 1.1)))
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
            .opacity(opacity)
        }
        .preferredColorScheme(.light)
        .onAppear {
            // Fade in the loading view
            withAnimation(.easeIn(duration: 0.3)) {
                opacity = 1
            }
            checkInitialState()
        }
    }
    
    private func checkInitialState() {
        print("\n--- Starting Initial State Check ---")
        
        // First check for conflicting apps
        let detector = AppDetector()
        hasConflictingApps = detector.hasConflictingApps()
        print("Initial check - Conflicting apps detected: \(hasConflictingApps)")
        
        // Then check Safari extension status
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: "io.banish.app.ContentBlockerExtension") { state, error in
            DispatchQueue.main.async {
                extensionEnabled = state?.isEnabled ?? false
                print("Initial check - Extension enabled: \(extensionEnabled)")
                
                // If we have conflicting apps OR extension is disabled, we need setup
                setupNeeded = hasConflictingApps || !extensionEnabled
                
                if setupNeeded {
                    // Reset to beginning of setup flow
                    currentStep = 1
                    appState.resetSetup()
                    print("Initial check - Setup needed, starting setup flow")
                } else {
                    // Everything is good, show How It Works
                    print("Initial check - No setup needed, showing How It Works")
                }
                
                // Delay removing loading screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isLoading = false
                    }
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
