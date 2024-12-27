import SwiftUI
import UIKit

struct AppDetectionView: View {
    @Binding var currentStep: Int
    @State private var installedApps: [String] = []
    
    var body: some View {
        VStack(spacing: 24) {
            // Header icon with gradient
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.red, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .red.opacity(0.3), radius: 10, x: 0, y: 5)
                .padding(.bottom, 8)
            
            if installedApps.isEmpty {
                // Success state - no apps found
                Text("No Conflicting Apps Found")
                    .font(.title2)
                    .bold()
                
                Text("You're ready to continue!")
                    .foregroundColor(.secondary)
                
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
            } else {
                Text("Please uninstall the following apps:")
                    .font(.headline)
                    .padding(.bottom, 8)
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(installedApps, id: \.self) { app in
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text(app)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
        .padding()
        .onAppear {
            checkInstalledApps()
        }
    }
    
    private func checkInstalledApps() {
        let detector = AppDetector()
        installedApps = detector.getInstalledApps()
    }
} 