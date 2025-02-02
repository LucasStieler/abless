import SwiftUI
import SafariServices

/// Final view shown when setup is complete
struct SuccessView: View {
    @StateObject private var appState = AppState()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var opacity = 1.0
    @State private var scale = 1.0
    
    var body: some View {
        VStack(spacing: 24) {
            // Success checkmark icon with gradient
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green, .mint],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
                .padding(.bottom, 8)
            
            // Success message
            Text("Setup Complete!")
                .font(.title)
                .bold()
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primary, .primary.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            // Success description
            Text("You can now enjoy YouTube, Instagram, and TikTok in Safari without distracting short videos!")
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            // Close app button with gradient
            Button(action: { 
                closeAppWithAnimation()
            }) {
                Text("Close App")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.green, .mint],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .opacity(opacity)
        .scaleEffect(scale)
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func closeAppWithAnimation() {
        checkExtensionStatus { isEnabled in
            if isEnabled {
                reloadContentBlocker()
                // Animate out
                withAnimation(.easeInOut(duration: 0.5)) {
                    opacity = 0
                    scale = 0.8
                }
                // Wait for animation to complete before exiting
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    exit(0)
                }
            } else {
                showingAlert = true
                alertMessage = "Please enable the Safari extension in Settings before closing the app."
            }
        }
    }
    
    private func checkExtensionStatus(completion: @escaping (Bool) -> Void = { _ in }) {
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: "io.banish.app.ContentBlockerExtension") { state, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error checking extension: \(error.localizedDescription)")
                        self.showingAlert = true
                        self.alertMessage = "Error checking extension: \(error.localizedDescription)"
                        completion(false)
                        return
                    }
                    
                    let isEnabled = state?.isEnabled ?? false
                    print("Extension status: \(isEnabled)")
                    self.appState.updateExtensionStatus(isEnabled)
                    completion(isEnabled)
                }
        }
    }
    
    private func reloadContentBlocker() {
        print("Reloading content blocker...")
        SFContentBlockerManager.reloadContentBlocker(
            withIdentifier: "io.banish.app.ContentBlockerExtension"
        ) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Reload error: \(error.localizedDescription)")
                    self.showingAlert = true
                    self.alertMessage = "Error reloading blocker: \(error.localizedDescription)"
                } else {
                    print("Content blocker reloaded successfully")
                }
            }
        }
    }
} 