import SwiftUI

struct LoadingView: View {
    @State private var opacity = 0.0
    @State private var scale = 0.8
    @State private var showMainContent = false
    
    // Text animation states
    @State private var textOpacity = 1.0
    @State private var textOffset: CGFloat = 0
    
    var body: some View {
        Group {
            if showMainContent {
                ContentView()
                    .transition(.opacity)
            } else {
                ZStack {
                    // Background gradient
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: 30) {
                        // App icon or logo
                        Image(systemName: "shield.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .opacity(opacity)
                            .scaleEffect(scale)
                        
                        // Single message text
                        Text("Let distracting short videos vanish")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .opacity(textOpacity)
                            .offset(x: textOffset)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            // Initial animation for icon and text
            withAnimation(.easeOut(duration: 0.8)) {
                opacity = 1
                scale = 1
            }
            
            // Text fade out
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    textOpacity = 0
                    opacity = 0
                    textOffset = -50
                }
            }
            
            // Transition to main content
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
                withAnimation(.easeIn(duration: 0.5)) {
                    showMainContent = true
                }
            }
        }
    }
} 