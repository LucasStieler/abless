import SwiftUI

/// View that guides users through logging into required platforms
struct SafariLoginView: View {
    /// Binding to track the current step in the setup process
    @Binding var currentStep: Int
    let isSetupComplete: Bool
    @State private var opacity: CGFloat = 1.0
    @State private var scale: CGFloat = 1.0
    
    /// Array of tuples containing platform names and their URLs
    private let platforms = [
        ("YouTube", "https://youtube.com"),
        ("Instagram", "https://instagram.com"),
        ("TikTok", "https://tiktok.com")
    ]
    
    var body: some View {
        VStack {
            // Content
            VStack(spacing: 24) {
                // Header icon
                Image(systemName: "link.circle.fill")
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
                Text("Log in to Platforms")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Log in to the following platforms in Safari:")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                
                // Platform links
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
            }
            .padding(.top, 60)
            
            Spacer()
            
            // Bottom button
            Button(action: {
                if isSetupComplete {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        opacity = 0
                        scale = 0.95
                    }
                } else {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        currentStep += 1
                    }
                }
            }) {
                Text(isSetupComplete ? "Close App" : "Continue")
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
        .smoothExit(opacity: $opacity, scale: $scale) {
            exit(0)
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
    }
}

#Preview {
    SafariLoginView(currentStep: .constant(4), isSetupComplete: false)
} 