import SwiftUI

struct LoadingView: View {
    @State private var opacity = 0.0
    @State private var scale = 0.8
    @State private var showMainContent = false
    @State private var textOpacity = 1.0
    @State private var textOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            // Content
            VStack(spacing: 32) {
                // App icon
                Image(systemName: "shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .opacity(opacity)
                    .scaleEffect(scale)
                    .frame(minWidth: 44, minHeight: 44)
                
                VStack(spacing: 16) {
                    // App name
                    Text("Banish")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(opacity)
                    
                    // Tagline
                    Text("Let distracting short videos vanish")
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(textOpacity)
                        .offset(x: textOffset)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.top, 160)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .onAppear {
            // Initial animation
            withAnimation(.easeOut(duration: 0.8)) {
                opacity = 1
                scale = 1
            }
            
            // Text fade out
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    textOpacity = 0
                    opacity = 0
                    textOffset = -50
                    scale = 1.1
                }
            }
        }
    }
}

#Preview {
    LoadingView()
} 