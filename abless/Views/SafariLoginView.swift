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
                .font(.title2)
                .bold()
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primary, .primary.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text("Log in to the following platforms in Safari:")
                .font(.headline)
                .foregroundColor(.secondary)
            
            // Platform links container
            VStack(spacing: 16) {
                ForEach(platforms, id: \.0) { platform, url in
                    Link(destination: URL(string: url)!) {
                        HStack {
                            Text(platform)
                                .font(.body)
                            Spacer()
                            Image(systemName: "arrow.up.right.circle.fill")
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        )
                        .foregroundColor(.primary)
                    }
                }
            }
            
            // Continue button with gradient styling
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    currentStep += 1
                }
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
            .padding(.top, 8)
        }
    }
} 