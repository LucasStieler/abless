import SwiftUI

/// View that guides users through enabling the Safari extension
struct SafariExtensionGuideView: View {
    /// Binding to track the current step in the setup process
    @Binding var currentStep: Int
    
    var body: some View {
        VStack(spacing: 24) {
            // Safari icon with gradient styling
            Image(systemName: "safari.fill")
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
            Text("Enable Safari Extension")
                .font(.title2)
                .bold()
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primary, .primary.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            // Steps container with numbered instructions
            VStack(alignment: .leading, spacing: 16) {
                StepRow(number: 1, text: "Open the Settings app")
                StepRow(number: 2, text: "Navigate to Safari → Extensions")
                StepRow(number: 3, text: "Enable Banish")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
            
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
        HStack(spacing: 12) {
            // Circular number indicator
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)
                Text("\(number)")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            // Step instruction text
            Text(text)
                .font(.body)
        }
    }
} 