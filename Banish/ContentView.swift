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
    
    var body: some View {
        NavigationView {
            VStack {
                switch currentStep {
                case 1:
                    WelcomeView(currentStep: $currentStep)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                case 2:
                    if setupNeeded {
                        AppDetectionView(currentStep: $currentStep)
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
                case 3:
                    if setupNeeded {
                        SafariExtensionGuideView(currentStep: $currentStep)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    } else {
                        SafariLoginView(currentStep: $currentStep)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    }
                case 4:
                    SafariLoginView(currentStep: $currentStep)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                case 5:
                    SuccessView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .onAppear {
                            appState.completeSetup()
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
        .preferredColorScheme(.light)
        .onAppear {
            checkInitialState()
        }
    }
    
    private func checkInitialState() {
        let detector = AppDetector()
        let hasApps = detector.hasConflictingApps()
        
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: "io.banish.app.ContentBlockerExtension") { state, error in
            DispatchQueue.main.async {
                let extensionDisabled = !(state?.isEnabled ?? false)
                setupNeeded = hasApps || extensionDisabled
                
                if hasApps {
                    currentStep = 2
                    appState.resetSetup()
                } else if extensionDisabled {
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
