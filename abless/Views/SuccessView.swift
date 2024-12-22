import SwiftUI
import SafariServices

/// Final view shown when setup is complete
struct SuccessView: View {
    @State private var extensionEnabled = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var gradientRotation = 0.0
    
    // Futuristic gradient colors
    private let gradientColors: [Color] = [
        .blue, .purple, .pink, .cyan
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Animated success icon with multi-color gradient
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundStyle(
                    AngularGradient(
                        colors: gradientColors,
                        center: .center,
                        angle: .degrees(gradientRotation)
                    )
                )
                .shadow(color: .blue.opacity(0.5), radius: 15, x: 0, y: 0)
                .padding(.bottom, 8)
                .onAppear {
                    withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                        gradientRotation = 360
                    }
                }
            
            // Success message with glowing effect
            Text("Setup Complete!")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: .blue.opacity(0.5), radius: 10)
            
            // Success description with modern styling
            Text("You can now enjoy YouTube, Instagram, and TikTok in Safari without distracting short videos!")
                .multilineTextAlignment(.center)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [.blue.opacity(0.5), .purple.opacity(0.5)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                )
            
            // Futuristic close button
            Button(action: { 
                checkAndReloadBlocker()
            }) {
                Text("Close App")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        ZStack {
                            // Animated gradient background
                            LinearGradient(
                                colors: [.cyan, .blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            
                            // Glassmorphism overlay
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial.opacity(0.3))
                        }
                    )
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
        .padding(24)
        .background(
            // Animated background gradient
            LinearGradient(
                colors: [.black, .blue.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .onAppear {
            checkExtensionStatus()
        }
        .alert("Extension Status", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {
                if extensionEnabled {
                    exit(0)
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func checkAndReloadBlocker() {
        checkExtensionStatus { isEnabled in
            if isEnabled {
                reloadContentBlocker()
                exit(0)
            } else {
                showingAlert = true
                alertMessage = "Please enable the Safari extension in Settings before closing the app."
            }
        }
    }
    
    private func checkExtensionStatus(completion: @escaping (Bool) -> Void = { _ in }) {
        SFContentBlockerManager.getStateOfContentBlocker(
            withIdentifier: "io.abless.ContentBlockerExtension") { state, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.showingAlert = true
                        self.alertMessage = "Error checking extension: \(error.localizedDescription)"
                        completion(false)
                        return
                    }
                    
                    self.extensionEnabled = state?.isEnabled ?? false
                    completion(self.extensionEnabled)
                }
        }
    }
    
    private func reloadContentBlocker() {
        SFContentBlockerManager.reloadContentBlocker(
            withIdentifier: "io.abless.ContentBlockerExtension") { error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.showingAlert = true
                        self.alertMessage = "Error reloading blocker: \(error.localizedDescription)"
                    }
                }
        }
    }
}

// Add extension status checking
func checkExtensionStatus() {
    SFContentBlockerManager.getStateOfContentBlocker(
        withIdentifier: "io.abless.ContentBlockerExtension") { state, error in
        // Update UI based on state
    }
} 