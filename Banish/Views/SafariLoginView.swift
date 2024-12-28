import SwiftUI

/// View that guides users through logging into required platforms
struct SafariLoginView: View {
    /// Binding to track the current step in the setup process
    @Binding var currentStep: Int
    
    /// Array of tuples containing platform names and their URLs
    private let platforms = [
        ("YouTube", "https://youtube.com"),
        ("Instagram", "https://instagram.com"),
        ("TikTok", "https://tiktok.com")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Header icon with gradient styling
            Image(systemName: "link.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                .padding(.bottom, 8)
            
            // Title section
            Text("Log in to Platforms")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text("Log in to the following platforms in Safari:")
                .font(.system(size: 17))
                .foregroundColor(.secondary)
            
            // Platform links container
            VStack(spacing: 16) {
                ForEach(platforms, id: \.0) { platform, url in
                    Link(destination: URL(string: url)!) {
                        HStack {
                            Text(platform)
                                .font(.system(size: 17))
                            Spacer()
                            Image(systemName: "arrow.up.right.circle.fill")
                        }
                        .padding()
                        .frame(width: 280)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                        .foregroundColor(.primary)
                    }
                }
            }
            
            Spacer()
            
            // Continue button
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    currentStep += 1
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
        .padding(.top, 60)
    }
}

#Preview {
    SafariLoginView(currentStep: .constant(4))
} 