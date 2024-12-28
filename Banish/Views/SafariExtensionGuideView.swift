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
        VStack(spacing: 24) {
            // Safari icon with gradient
            Image(systemName: "safari.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(minWidth: 44, minHeight: 44)
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                .padding(.bottom, 8)
            
            // Title section
            Text("Enable Safari Extension")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            // Steps container
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
            
            // Continue button
            Button(action: {
                checkExtensionAndContinue()
            }) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
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
            .padding(.horizontal, 24)
            .frame(maxWidth: 500)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 20)
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
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            checkExtensionStatus()
        }
    }
    
    private func checkExtensionAndContinue() {
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: "io.banish.app.ContentBlockerExtension") { state, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error checking extension: \(error.localizedDescription)")
                    showingAlert = true
                    return
                }
                
                let isEnabled = state?.isEnabled ?? false
                print("Extension status: \(isEnabled)")
                appState.updateExtensionStatus(isEnabled)
                
                if isEnabled {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        currentStep += 1
                    }
                } else {
                    showingAlert = true
                }
            }
        }
    }
    
    private func checkExtensionStatus() {
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: "io.banish.app.ContentBlockerExtension") { state, error in
            DispatchQueue.main.async {
                let newStatus = state?.isEnabled ?? false
                if newStatus != extensionEnabled {
                    withAnimation {
                        extensionEnabled = newStatus
                        if extensionEnabled {
                            currentStep += 1
                        }
                    }
                }
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