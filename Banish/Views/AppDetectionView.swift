import SwiftUI

struct AppDetectionView: View {
    @Binding var currentStep: Int
    @State private var installedApps: [String] = []
    @Environment(\.scenePhase) private var scenePhase
    
    // Add timer control
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 24) {
            // Header icon with gradient
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: installedApps.isEmpty ? 
                            [.green, .mint] :
                            [.red, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(minWidth: 44, minHeight: 44)
                .shadow(color: installedApps.isEmpty ? 
                    .green.opacity(0.3) : 
                    .red.opacity(0.3),
                       radius: 10, x: 0, y: 5)
                .padding(.bottom, 8)
            
            if installedApps.isEmpty {
                // Success state
                Text("No Conflicting Apps Found")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("You're ready to continue!")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        currentStep += 1
                    }
                }) {
                    Text("Continue")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(height: 50)
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
                .padding(.horizontal, 24)
                .frame(maxWidth: 500)
            } else {
                // Warning state
                Text("Please uninstall the following apps:")
                    .font(.system(size: 22, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
                
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(installedApps, id: \.self) { app in
                        HStack(spacing: 12) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 22))
                            Text(app)
                                .font(.system(size: 17))
                                .foregroundColor(.primary)
                        }
                        .frame(minHeight: 44)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 20)
        .onAppear {
            checkInstalledApps()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                checkInstalledApps()
                startTimer()
            } else {
                stopTimer()
            }
        }
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            checkInstalledApps()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkInstalledApps() {
        let detector = AppDetector()
        let newApps = detector.getInstalledApps()
        if newApps != installedApps {
            withAnimation {
                installedApps = newApps
            }
        }
    }
}

#Preview {
    AppDetectionView(currentStep: .constant(2))
} 