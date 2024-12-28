import SwiftUI

struct HowItWorksView: View {
    @Binding var currentStep: Int
    var isSetupComplete: Bool
    @State private var opacity: CGFloat = 1
    @State private var scale: CGFloat = 1
    
    let steps = [
        (icon: "exclamationmark.triangle.fill", title: "App Detection", description: "Banish checks for apps with distracting short videos like YouTube, Instagram, and TikTok."),
        (icon: "safari.fill", title: "Safari Extension", description: "The Safari content blocker extension removes short video sections from these platforms."),
        (icon: "link.circle.fill", title: "Platform Access", description: "Access your favorite platforms through Safari for a distraction-free experience.")
    ]
    
    var body: some View {
        VStack {
            // Content
            VStack(spacing: 24) {
                // Header icon
                Image(systemName: "shield.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.green, .mint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(minWidth: 44, minHeight: 44)
                    .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
                    .padding(.bottom, 8)
                
                // Success state
                Text("Ready to Go")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Everything is set up correctly!")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 16)
                
                // How it works section
                Text("How Does It Work?")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
                
                // Steps
                VStack(spacing: 24) {
                    ForEach(steps.indices, id: \.self) { index in
                        HStack(spacing: 16) {
                            // Step icon
                            Image(systemName: steps[index].icon)
                                .font(.system(size: 24))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 44, height: 44)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(steps[index].title)
                                    .font(.system(size: 17, weight: .semibold))
                                Text(steps[index].description)
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .frame(maxWidth: 280, alignment: .leading)
                    }
                }
            }
            .padding(.top, 60)
            
            Spacer()
            
            // Bottom button
            if isSetupComplete {
                Button("Start Browsing") {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        currentStep += 1
                    }
                }
                .buttonStyle(SubtleButtonStyle())
            } else {
                Button("Close App") {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        opacity = 0
                        scale = 0.95
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
            }
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

extension View {
    func primaryButtonStyle() -> some View {
        self.buttonStyle(PrimaryButtonStyle())
    }
}

#Preview {
    HowItWorksView(currentStep: .constant(2), isSetupComplete: true)
} 