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
    @State private var opacity: CGFloat = 0
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    LoadingView()
                        .transition(
                            .asymmetric(
                                insertion: .opacity,
                                removal: .opacity.combined(with: .scale(scale: 1.1))
                            )
                        )
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
                        default:
                            WelcomeView(currentStep: $currentStep)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
            .animation(.easeInOut(duration: 0.6), value: isLoading)
            .opacity(opacity)
        }
        .preferredColorScheme(.light)
        .onAppear {
            withAnimation(.easeIn(duration: 0.3)) {
                opacity = 1
            }
            checkInitialState()
        }
    }
    
    private func checkInitialState() {
        let detector = AppDetector()
        hasConflictingApps = detector.hasConflictingApps()
        
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: "io.banish.app.ContentBlockerExtension") { state, error in
            DispatchQueue.main.async {
                extensionEnabled = state?.isEnabled ?? false
                setupNeeded = hasConflictingApps || !extensionEnabled
                
                if setupNeeded {
                    currentStep = 1
                    appState.resetSetup()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        isLoading = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
