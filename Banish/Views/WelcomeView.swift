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
                .frame(minWidth: 44, minHeight: 44)
                .padding(.bottom, 8)
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
            
            // Title with proper text size and contrast
            Text("Welcome to Banish")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.primary)
                .multilineTextAlignment(.center)
            
            // Description with minimum 11pt text
            Text("This app helps you block distracting short videos like YouTube Shorts, Instagram Reels, and TikTok videos.")
                .font(.system(size: 17))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                .lineSpacing(4)
            
            Spacer()
            
            // Continue button with proper sizing and spacing
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    currentStep += 1
                }
            }) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(height: 50)
                    .frame(width: 280) // Standard button width
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
            .padding(.bottom, 16) // Safe area padding
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 60) // Top padding for visual balance
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
    }
}

#Preview {
    WelcomeView(currentStep: .constant(1))
} 