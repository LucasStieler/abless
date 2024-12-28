import SwiftUI
import SafariServices

/// View that guides users through logging into required platforms
struct SafariLoginView: View {
    /// Binding to track the current step in the setup process
    @Binding var currentStep: Int
    
    var body: some View {
        VStack(spacing: 24) {
            // Safari icon
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
            
            Text("Log in to Safari")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text("Please log in to your iCloud account in Safari settings to enable content blocking.")
                .font(.system(size: 17))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 16) {
                // Open Settings button
                Button(action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Open Settings")
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
                
                // Continue button
                Button(action: {
                    withAnimation {
                        currentStep += 1
                    }
                }) {
                    Text("Continue")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(width: 280, height: 50)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 60)
    }
}

#Preview {
    SafariLoginView(currentStep: .constant(4))
} 