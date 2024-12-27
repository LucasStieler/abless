import SwiftUI
import UIKit

struct AppDetectionView: View {
    @Binding var currentStep: Int
    @State private var installedApps: [String] = []
    
    private let appSchemes = [
        "youtube": [
            "youtube://",
            "vnd.youtube://",
            "youtube-app://",
            "com.google.ios.youtube://"
        ],
        "instagram": [
            "instagram://",
            "instagram-stories://"
        ],
        "tiktok": [
            "tiktok://",
            "snssdk1233://"
        ]
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: installedApps.isEmpty ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                .font(.system(size: 70))
                .foregroundStyle(
                    LinearGradient(
                        colors: installedApps.isEmpty ? 
                            [.green, .mint] : 
                            [.red, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: installedApps.isEmpty ? .green.opacity(0.3) : .red.opacity(0.3), 
                        radius: 10, x: 0, y: 5)
            
            Text("App Detection")
                .font(.title2)
                .bold()
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primary, .primary.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            if installedApps.isEmpty {
                Text("No conflicting apps found!")
                    .foregroundColor(.green)
                    .font(.headline)
                
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
                                colors: [.green, .mint],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
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
                
                Button(action: { checkInstalledApps() }) {
                    Text("I have uninstalled the apps")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!installedApps.isEmpty)
            }
        }
        .onAppear { checkInstalledApps() }
    }
    
    private func checkInstalledApps() {
        installedApps = []
        
        print("Checking for installed apps...")
        
        for (app, schemes) in appSchemes {
            for scheme in schemes {
                if let url = URL(string: scheme) {
                    if UIApplication.shared.canOpenURL(url) {
                        print("Found installed app: \(app) with scheme: \(scheme)")
                        installedApps.append(app.capitalized)
                        break
                    } else {
                        print("Could not open URL scheme: \(scheme)")
                    }
                }
            }
        }
        
        print("Installed apps found: \(installedApps)")
    }
} 