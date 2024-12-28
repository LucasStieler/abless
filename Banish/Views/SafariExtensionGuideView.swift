import SwiftUI
import SafariServices

/// View that guides users through enabling the Safari extension
struct SafariExtensionGuideView: View {
    /// Binding to track the current step in the setup process
    @Binding var currentStep: Int
    @StateObject private var appState = AppState()
    @State private var showingAlert = false
    @State private var extensionEnabled = false
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack {
            // Content
            VStack(spacing: 24) {
                // Safari icon with gradient
                Image(systemName: "safari.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: extensionEnabled ? 
                                [.green, .mint] :
                                [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(minWidth: 44, minHeight: 44)
                    .shadow(color: extensionEnabled ? 
                        .green.opacity(0.3) : 
                        .blue.opacity(0.3),
                               radius: 10, x: 0, y: 5)
                    .padding(.bottom, 8)
                
                if extensionEnabled {
                    // Success state
                    Text("Safari Extension Enabled")
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    Text("You're ready to continue!")
                        .font(.system(size: 17))
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                } else {
                    // Setup state
                    Text("Enable Safari Extension")
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        StepRow(number: 1, text: "Open the Settings app")
                        StepRow(number: 2, text: "Navigate to Safari → Extensions")
                        StepRow(number: 3, text: "Enable Banish")
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                    .padding(.horizontal, 24)
                }
            }
            .padding(.top, 60)
            
            Spacer()
            
            // Bottom button
            Button(action: {
                if extensionEnabled {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        currentStep += 1
                    }
                } else {
                    checkExtensionAndContinue()
                }
            }) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(width: 280, height: 50)
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .buttonStyle(.plain)
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
        .alert("Extension Not Enabled", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please enable the Safari extension in Settings before continuing.")
        }
        .onAppear {
            checkExtensionStatus()
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                checkExtensionStatus()
            }
        }
    }
    
    private func checkExtensionAndContinue() {
        checkExtensionStatus()
        if !extensionEnabled {
            showingAlert = true
        }
    }
    
    private func checkExtensionStatus() {
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: "io.banish.app.ContentBlockerExtension") { state, error in
            DispatchQueue.main.async {
                extensionEnabled = state?.isEnabled ?? false
            }
        }
    }
}

/// Reusable component for displaying numbered steps
struct StepRow: View {
    /// The step number to display
    let number: Int
    /// The instruction text for this step
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Number indicator
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                Text("\(number)")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Step text
            Text(text)
                .font(.system(size: 17))
                .foregroundColor(.primary)
        }
        .frame(minHeight: 44)
    }
}

#Preview {
    SafariExtensionGuideView(currentStep: .constant(3))
} 