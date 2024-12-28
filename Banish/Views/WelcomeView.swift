import SwiftUI

struct WelcomeView: View {
    @Binding var currentStep: Int
    
    var body: some View {
        VStack(spacing: 24) {
            // Animated gradient icon - at least 44x44pt
            Image(systemName: "shield.slash.fill")
                .font(.system(size: 70))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(minWidth: 44, minHeight: 44) // Minimum touch target
                .padding(.bottom, 8)
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
            
            // Title with proper text size and contrast
            Text("Welcome to Banish")
                .font(.system(size: 28, weight: .bold)) // Large, readable text
                .foregroundStyle(Color.primary) // High contrast
                .multilineTextAlignment(.center)
            
            // Description with minimum 11pt text
            Text("This app helps you block distracting short videos like YouTube Shorts, Instagram Reels, and TikTok videos.")
                .font(.system(size: 17)) // Body text size
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 24) // Proper margins
                .lineSpacing(4) // Improved readability
            
            // Continue button with proper sizing and spacing
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    currentStep += 1
                }
            }) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(height: 50) // Comfortable touch target
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
            .padding(.horizontal, 24) // Standard side margins
            .frame(maxWidth: 500) // Maximum width for larger devices
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill available space
        .padding(.vertical, 20) // Vertical padding
    }
}

#Preview {
    WelcomeView(currentStep: .constant(1))
} 